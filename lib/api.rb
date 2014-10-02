# Consumer of the worker API.

require_relative 'rest_wrapper'
require 'json'
require 'aws-sdk'
require 'pathname'
require 'open-uri'

module HyraxApi
	# Versioning to match API
	class V1 
		def initialize(endpoint, key, job_id, results_bucket)
			@s3 = AWS::S3.new
			@url = "#{endpoint}/v1/worker"
			@api_key = key
			@job_id = job_id
			@results = @s3.buckets[results_bucket]
			RestWrapper.set_error_method(method(:error))
		end
		def error(msg) 
			puts "API communication error: \n#{msg}\n"
		end
		def get_job
			response = RestWrapper.get("#{@url}/jobs/#{@job_id}?worker_key=#{@api_key}", 'Error while fetching a job')
		    begin
				JSON.parse(response.body)['job']
		    rescue
				error 'Error when fetching job from API'
		    end
		end
		def update_job(job)
			RestWrapper.put("#{@url}/jobs/#{@job_id}", {worker_key: @api_key, job: job}.to_json, 'Error while uploading completed job record')
		end
		def create_result(result)
			response = RestWrapper.post("#{@url}/jobs/#{@job_id}/results", {api_key: @api_key, job_result: result}.to_json, 'Error while uploading results record')
			begin
				JSON.parse(response.body)['result']
			rescue
				error 'Error when saving result record'
			end
		end
		def download_input_file(url, destination)
			open(destination, 'wb') do |file|
				file << open(url).read
			end
		end
		def upload_result_file(file)
			path = Pathname.new(file)
			obj = @results.objects["#{@job_id}/#{path.basename}"]
			obj.write(path)
		end
	end
end