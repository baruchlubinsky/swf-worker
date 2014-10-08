require_relative 'job_activity'

class Seq2resWorkflow
  extend AWS::Flow::Workflows

  workflow :seq2res do
    {
      version: WorkerUtils::WF_VERSION,
      #task_list: WorkerUtils::WF_TASKLIST,
      #execution_start_to_close_timeout: 24 * 60 * 60,
    }
  end

  activity_client(:client) { { from_class: "JobActivity" } }

  def seq2res(job_id)
    client.download_data(job_id)
    client.run_job(job_id)
    client.upload_results(job_id)
  end
end

# WorkerUtils.new.workflow_worker(Seq2resWorkflow).start if $0 == __FILE__