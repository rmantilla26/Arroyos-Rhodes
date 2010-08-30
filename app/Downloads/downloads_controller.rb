require 'application_controller'
require 'rho/rhocontroller'

class DownloadsController < Rho::RhoController
  

  #GET /Downloads
  def index
    @downloadses = Downloads.find(:all)
    puts "raul lista de descargas #{@downloadses.inspect}"
    render :action=>:index
  end

  # GET /Downloads/{1}
  def show
    @downloads = Downloads.find(@params['id'])
    if @downloads
      render :action => :show
    else
      redirect :action => :index
    end
  end

  # GET /Downloads/new
  def new
    @downloads = Downloads.new
    render :action => :new
  end

  # GET /Downloads/{1}/edit
  def edit
    @downloads = Downloads.find(@params['id'])
    if @downloads
      render :action => :edit
    else
      redirect :action => :index
    end
  end

  # POST /Downloads/create
  def create
    puts "raul params for create #{@params['downloads'].inspect}"
    @downloads = Downloads.new(@params['downloads'])
    @downloads.save
    redirect :action => :index
  end

  # POST /Downloads/{1}/update
  def update
    @downloads = Downloads.find(@params['id'])
    @downloads.update_attributes(@params['downloads']) if @downloads
    redirect :action => :index
  end

  # POST /Downloads/{1}/delete
  def delete
    @downloads = Downloads.find(@params['id'])
    @downloads.destroy if @downloads
    redirect :action => :index
  end
end
