require_relative 'worker_utils'
require_relative 'job_utils'

# Defines a set of activities 
class JobActivity
  extend AWS::Flow::Activities

  # define an activity with the #activity method.
  activity :run_job do
    {
      version: WorkerUtils::ACTIVITY_VERSION,
      #default_task_list: WorkerUtils::ACTIVITY_TASKLIST,
      # timeout values are in seconds.
      #default_task_schedule_to_start_timeout: 60 * 60,
      #default_task_start_to_close_timeout: 24 * 60 * 60
    }
  end

  # Exectue the relevant tool
  def run_job(name)
    puts "run, #{name}!"
  end

  # define an activity with the #activity method.
  activity :download_data do
    {
      version: WorkerUtils::ACTIVITY_VERSION,
      default_task_list: WorkerUtils::ACTIVITY_TASKLIST,
      # timeout values are in seconds.
      default_task_schedule_to_start_timeout: 60 * 60,
      default_task_start_to_close_timeout: 24 * 60 * 60
    }
  end

  # This activity will say hello when invoked by the workflow
  def download_data(job_id)
    puts "download, #{job_id}!"
    job = JobController.new(job_id)
    job.setup
  end

  # define an activity with the #activity method.
  activity :upload_results do
    {
      version: WorkerUtils::ACTIVITY_VERSION,
      default_task_list: WorkerUtils::ACTIVITY_TASKLIST,
      # timeout values are in seconds.
      default_task_schedule_to_start_timeout: 60 * 60,
      default_task_start_to_close_timeout: 24 * 60 * 60
    }
  end

  # This activity will say hello when invoked by the workflow
  def upload_results(job_id)
    puts "uploading, #{job_id}!"
    job.complete
  end

end

# Start an ActivityWorker to work on the JobActivity tasks
# WorkerUtils.new.activity_worker(JobActivity).start if $0 == __FILE__