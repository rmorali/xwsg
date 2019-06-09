class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  def after_sign_in_path_for(_resource)
    if current_user.squad
      root_path
    else
      new_squad_path
    end
  end
  
  def current_squad
    current_user.squad if current_user
  end
  
end
