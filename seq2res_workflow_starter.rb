require_relative 'worker_utils'
require_relative 'seq2res_workflow'
require_relative 'job_activity'

WorkerUtils.new.workflow_client(Seq2resWorkflow).start_execution("AWS Flow Framework")