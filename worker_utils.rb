require 'aws/decider'

class WorkerUtils
  WF_VERSION = "0.0.1"
  ACTIVITY_VERSION = "0.0.1"
  WF_TASKLIST = "workflow_tasklist"
  ACTIVITY_TASKLIST = "activity_tasklist"
  DOMAIN = "HyraxDev"

  def initialize
    AWS.config({region: 'eu-west-1'}) 
    swf = AWS::SimpleWorkflow.new
    @domain = swf.domains[DOMAIN]
    unless @domain.exists?
      @domain = swf.domains.create(DOMAIN, 10)
    end
  end

  def activity_worker(klass)
    AWS::Flow::ActivityWorker.new(@domain.client, @domain, ACTIVITY_TASKLIST, klass)
  end

  def workflow_worker(klass)
    AWS::Flow::WorkflowWorker.new(@domain.client, @domain, WF_TASKLIST, klass)
  end

  def workflow_client(klass)
    AWS::Flow::workflow_client(@domain.client, @domain) { { from_class: klass.name } }
  end
end