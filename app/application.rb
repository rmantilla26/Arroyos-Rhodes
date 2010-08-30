require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    super
    Rho::RhoConfig.online = "2"
    @menu = {"Profile"=> "/app/Accounts/profile","Friends"=> "/app/Friends/index",
      "Scraps"=> "/app/Home/demo",
      "Photos"=> "/app/Home/demo",
      "Video"=> "/app/Home/demo",
      "More"=> "/app/Home/demo",
      "Sign Out"=> "/app/Settings/login"}
  end

end
