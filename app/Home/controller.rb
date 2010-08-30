require 'rho/rhocontroller'
require 'application_controller'
require 'rexml/document'
require 'uri'

class HomeController < Rho::RhoController

  def index
    if Rho::RhoConfig.demoserver.nil? or Rho::RhoConfig.demoserver==""
      redirect :controller=>"Settings", :action=>:change_server_address
    end
    Searchs.delete_all
    @ip="http://#{Rho::RhoConfig.demoserver}/archivos.php"
    puts "entro home index #{@ip.inspect}"
    @menu = {"Settings"=> "/app/Settings/change_server_address","Close"=>:close}
    do_connection
    render :action=>"wait"
  end

  def do_connection
    Rho::AsyncHttp.get(:url => "#{@ip}",:callback => (url_for :action => :httpsearch_callback))
  end

  def cancel_connection
    Rho::AsyncHttp.cancel( url_for( :action => :httpsearch_callback) )
    redirect :controller=>"Settings",:action => :change_server_address, :back => '/app'
  end
  
  def httpsearch_callback
    puts "httsearch_callback #{@params}"
    if @params['status'] == 'error'
      @@error_params = @params
      WebView.navigate(url_for :action => :show_error_search)
    else
      puts "result xml from url #{@params.inspect}"
      if !@params['body'].nil?
        xml={}
        xml["body"]=@params['body']
        @search = Searchs.find(:all)
        @search.each do |sear|
          sear.destroy if sear
        end
        @search = Searchs.new(xml)
        @search.save
        puts "result from rhoconfig : #{@search.inspect}"
      end
      @menu = {"Settings"=> "/app/Settings/change_server_address","Close"=>:close}
      WebView.navigate(url_for :controller=>"Searchs",:action=>:index )
    end
  end

  def show_error_search
    Alert.show_popup "No se pudo establecer la conexión con el servidor, verifique que la dirección sea valida"
    redirect :controller=>"Settings", :action => :change_server_address, :back => '/app'
  end
end