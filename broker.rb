require "aws-sdk"
require_relative 'lib/worker_utils'
require_relative 'lib/seq2res_workflow'
require_relative 'lib/job_activity'

@stop = false

Signal.trap('INT') do
  @stop = true
  puts "[INFO] Ctrl+C shutting down. \n"
end
# Connect to the queue
sqs = AWS::SQS.new({region: ENV['HYRAX_WORK_QUEUE_REGION']})
queue = sqs.queues.named(ENV['HYRAX_WORK_QUEUE'])
# poll indefinitely
queue.poll do |msg|
	unless msg.nil?
		puts "[INFO] Received #{msg.body}"
		begin
			message = JSON.parse(msg.body)
		rescue JSON::ParserError
			puts "[ERROR] Unable to parse message"
			msg.delete
			next
		end
		case message['tool']
		when 'seq2res'
			id = message['id']
			if id.nil?
				puts "[ERROR] Missing required key 'id'"
			else
				WorkerUtils.new.workflow_client(Seq2resWorkflow).start_execution(id)
			end
		else
			puts "[ERROR] Unknown tool: #{message['tool']}"
		end
		msg.delete
		if @stop
			break
		end
	end
end

exit 0