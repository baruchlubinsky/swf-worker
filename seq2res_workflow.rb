require_relative 'worker_utils'
require_relative 'job_activity'

class Seq2resWorkflow
  extend AWS::Flow::Workflows

  workflow :hello do
    {
      version: WorkerUtils::WF_VERSION,
      task_list: WorkerUtils::WF_TASKLIST,
      execution_start_to_close_timeout: 24 * 60 * 60,
    }
  end

  activity_client(:client) { { from_class: "JobActivity" } }

  def hello(name)
    client.run_job(name)
  end
end

WorkerUtils.new.workflow_worker(Seq2resWorkflow).start if $0 == __FILE__