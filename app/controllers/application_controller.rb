class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    unless Squad.count > 0
      unless current_user.squad
        new_squad_path
      end
    else

    end
  end
end
