class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  around_action :switch_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authorize_role

  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  protected

  def configure_permitted_parameters
    # For signup
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])

    # For account update (optional)
    update_attrs = [ :password, :password_confirmation, :current_password, :email ]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  private
  # Default: allow all roles. Override in child controllers.
  def authorize_role
    # Do nothing
  end

  def require_admin!
    redirect_to root_path, alert: "Access denied! Only admin can perform this action." unless current_user.is_admin?
  end

  def require_login!
      unless user_signed_in?
        redirect_to new_user_session_path, alert: "Please sign in"
      end
    end


  def require_owner!(resource) # avoid someone fake your id, except admin
      if resource.nil?
        if !user_signed_in?
            if params[:user_id].present? && current_user.id != params[:user_id].to_i
              render template: "layouts/error/unauthorized", status: :forbidden and return
            elsif resource.profile.user_id != current_user.id
              render template: "layouts/error/unauthorized", status: :forbidden and return
            end
        end

      elsif resource.profile.user_id != current_user.id
          render template: "layouts/error/unauthorized", status: :forbidden and return
      end
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # Redirect to Photos in feed after signin
  def after_sign_in_path_for(resource)
    root_path
  end
end
