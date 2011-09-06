class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def watch_interval
    @sites = Site.find(:all)
  end

end
