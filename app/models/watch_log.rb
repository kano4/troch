class WatchLog < ActiveRecord::Base
  belongs_to :site
  validates_presence_of :status

  def self.delete_old_logs
    self.delete_all(["created_at < ?", 1.month.ago])
  end
end
