class Group < ActiveRecord::Base
  has_many :sites
  validates_presence_of :name
end
