require 'rho'
require 'rho/rhocontroller'
require 'application_controller'
require 'rho/rhoerror'

class SettingsController < Rho::RhoController

  def change_server_address
    render
  end


  def set_server_address
    Rho::RhoConfig.demoserver=@params["address"]
    redirect :controller=>"Home", :action=>:index
  end
  
end
