# coding: utf-8
class SitesController < ApplicationController
  before_filter :authenticate_user!
  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.json
  def new
    @users = User.find(:all)
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @users = User.find(:all)
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.json
  def create
    params[:site][:user_ids] ||= []
    @users = User.find(:all) if @users.nil?
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render json: @site, status: :created, location: @site }
      else
        format.html { render action: "new" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.json
  def update
    params[:site][:user_ids] ||= []
    @users = User.find(:all) if @users.nil?
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site = Site.find(params[:id])
    @watch_logs = @site.watch_logs.find(:all)
    @site.destroy
    @watch_logs.each do |watch_log|
      watch_log.destroy
    end

    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :ok }
    end
  end

end
