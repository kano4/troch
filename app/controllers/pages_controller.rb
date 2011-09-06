class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @watchlogs = WatchLog.find(:all, :limit => 10, :order => "updated_at DESC")
  end

end
