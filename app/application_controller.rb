require 'rho/rhocontroller'

class ApplicationController < Rho::RhoController

  def initialize
    #do nothing
  end
  
  def show_msg_div
    if @msg!="" and !@msg.nil?
      @msg_class="msg_ok"
    elsif @msg_error!="" and !@msg_error.nil?
      @msg_class="msg_error"
      @msg=@msg_error
    else
      @msg_class=""
    end
    puts "<div class='#{@msg_class}'>#{@msg}</div>"
    "<div class=#{@msg_class}>#{@msg}</div>"  if @msg!="" and !@msg.nil?
  end
 
end
 