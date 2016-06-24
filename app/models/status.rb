class Status < ActiveRecord::Base
  WAIT_TO_DEPLOY = 1
  DEPLOYING = 2
  DEPLOYED = 3
  ROLLBACK = 4
  OPEN = 5
  FINISH = 6
  CANCELLED = 7

  NEXT_STATUS = {
    WAIT_TO_DEPLOY => DEPLOYING,
    DEPLOYING => DEPLOYED
  }

  validates :name, presence: true, length: { maximum: 30 }

  def next
    NEXT_STATUS[id]
  end

  def self.release_status
    Rails.cache.fetch("release_status", :expires_in => 1.day) do
      self.find(OPEN, FINISH)
    end
  end

  def self.deployment_status
    Rails.cache.fetch("deployment_status", :expires_in => 1.day) do
      self.find(WAIT_TO_DEPLOY, DEPLOYING, DEPLOYED, ROLLBACK, CANCELLED)
    end
  end
end
