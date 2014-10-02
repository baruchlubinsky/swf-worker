# Each of these funcitons must be independant. As they are called asynchronously from aws-flow.

require_relative 'api'
require 'fileutils'
require 'pathname'

class JobController
	def initialize(id)
		@job_id = id
		@working_dir = PathName.new(ENV["HYRAX_WORKER_ROOT"]).join(job_id)
		@api = HyarxApi::V1.new(ENV['HYRAX_API_HOST'], ENV['WORKER_KEY'], job_id, ENV['HYRAX_RESULT_BUCKET'])
	end
	def setup
		@job = @api.get_job
		FileUtils.mkpath(@working_dir)
		@job[:inputs].each do |input|
			safe_name = input[:name].gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_')
			dest = @working_dir.join(safe_name)
			@api.download_input_file(input[:signed_url], dest)
		end
	end
	def complete
		@job[:status] = 0
		@api.update_job(@job)
	end
	def error
		@job[:status] = 1
		@api.update_job(@job)
	end
end