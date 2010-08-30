require 'rho/rhocontroller'
require 'application_controller'
require 'rexml/document'
require 'uri'

class SearchsController < Rho::RhoController

  def index
    #    path_folder=@params["folder"];
    #    path_file=@params["file"];
    @search=Searchs.find(:first)
    puts "search : #{!@search.nil?}"
    puts "search body : #{!@search.body.nil?}"
    puts "search !Rho::RhoConfig.demoserver.nil? : #{!Rho::RhoConfig.demoserver.nil?}"
    puts "search !Rho::RhoConfig.demoserver.empty? : #{!Rho::RhoConfig.demoserver.empty?}"
    if !@search.nil? and !@search.body.nil? and !Rho::RhoConfig.demoserver.nil? and !Rho::RhoConfig.demoserver.empty?
      doc = REXML::Document.new(@search.body)
      @file_result = REXML::XPath.each( doc, "//root/file/" )
      @folder_result = REXML::XPath.each( doc, "//root/folder/" )
      puts "*"*90
      puts @file_result.inspect
      puts "*"*90
      puts @folder_result.inspect
      puts "*"*90
      @menu = {"Settings"=> "/app/Settings/change_server_address","Descargas"=> "/app/Downloads/index","Recargar"=> "/app/Home/index","Close"=>:close}
      render :index
    else
      redirect :controller=>"Settings", :action=>:change_server_address
    end
    
  end

  def download_file
    url=URI.escape(@params['url'])
    @name=@params['name']
    @type=@params['type']
    @@file_name = File.join(Rho::RhoApplication::get_app_path("files"), @name)

    Rho::AsyncHttp.download_file(
      :url => url,
      :filename => @@file_name,
      :headers => {},
      :callback => (url_for :action => :httpdownload_callback),
      :callback_param => "name=#{@name}&type=#{@type}" )

    render :action => :wait
  end

  def upload_file
    @name=@params['name']
    @type=@params['type']
    url="http://#{Rho::RhoConfig.demoserver}/subir_archivos.php"
    url=URI.escape(url)
    @@file_name = File.join(Rho::RhoApplication::get_app_path("files"), @name)
    Rho::AsyncHttp.upload_file(
      :url => url,
      :filename => @@file_name,
      :name=>"file",
      :headers => {},
      :callback => (url_for :action => :httpupload_callback),
      :callback_param => "" )
    render :action => :wait_upload
  end

  def httpdownload_callback
    puts "httpdownload_callback: #{@params}"
    puts "params name:: #{@params['name']}"
    puts "params type:: #{@params['type']}"
    if @params['status'] == 'error'
      @@error_params = @params
      WebView.navigate(url_for :action => :show_error)
    else
      WebView.navigate(URI.escape("/app/Searchs/show_result?name=#{@params['name']}&type=#{@params['type']}"))
    end
  end

  def httpupload_callback
    puts "httpupload_callback #{@params}"
    if @params['status'] == 'error'
      @@error_params = @params
      WebView.navigate( url_for :action => :show_error_upload )
    else
      WebView.navigate( url_for :action => :show_result_upload )
    end
  end

  def show_result
    Alert.show_popup "El archivo fue descargado correctamente"
    puts "hash de archivos descargados #{@params.inspect}"
    hash_value={:name=>@params['name'],:type=>@params['type']}
    @download = Downloads.new(hash_value)
    @download.save
    redirect :action => :index, :back => '/app'
  end

  def show_error
    Alert.show_popup "Ocurrio un error al descargar el archivo, intente nuevamente"
    redirect :action => :index, :back => '/app'
  end

  def show_result_upload
    Alert.show_popup "El archivo fue cargado correctamente"
    redirect :controller=>"Home",:action => :index, :back => '/app'
  end

  def show_error_upload
    Alert.show_popup "Ocurrio un error al cargar el archivo, intente nuevamente"
    redirect :action => :index, :back => '/app'
  end

  def cancel_upload_httpcall
    Rho::AsyncHttp.cancel( url_for( :action => :httpupload_callback) )
    Alert.show_popup "La carga del archivo fue cancelada por el usuario"
    @@get_result  = 'Request was cancelled.'
    redirect :action => :index, :back => '/app'
  end

  def cancel_download_httpcall
    Rho::AsyncHttp.cancel( url_for( :action => :httpdownload_callback))
    Alert.show_popup "La descarga del archivo fue cancelada por el usuario"
    @@get_result  = 'Request was cancelled.'
    redirect :action => :index, :back => '/app'
  end

  def show
    puts "mostrar carpeta :#{Rho::RhoApplication::get_blob_path("/app/files").inspect}"
  end

end
