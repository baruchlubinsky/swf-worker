require 'aws/decider'
require_relative 'worker_utils'
require_relative 'seq2res_workflow'

# get the path to the runner configuration file.
# if ARGV.length < 1
#   puts "Please provide the path to the runner configuration file!"
#   exit
# end
# runner_spec = ARGV[0]

swf = WorkerUtils.new
domain = swf.domain

client = swf.workflow_client("Seq2resWorkflow")

id = ARGV[1] || 6

puts "Running seq2res #{id}"
puts client.inspect

client.start_execution(id)