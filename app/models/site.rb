class Site < ActiveRecord::Base
  has_many :users_sites
  has_many :users, :through => :users_sites
  validates_presence_of :name, :url
end
