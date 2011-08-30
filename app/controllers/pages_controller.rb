class PagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @watchlogs = WatchLog.find(:all, :order => "updated_at DESC")
  end

end
