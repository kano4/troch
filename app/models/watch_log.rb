class WatchLog < ActiveRecord::Base
  belongs_to :site
  validates_presence_of :status
end
