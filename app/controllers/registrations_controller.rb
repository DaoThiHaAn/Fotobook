class RegistrationsController < Devise::RegistrationsController
  protected
    # Stay in the Profile file after editing
    def after_update_path_for(resource)
      edit_user_registration_path
    end

    # Redirect to Photos in feed after signin
    def after_sign_in_path_for(resource)
      user_feeds_photos_path(resource)
    end
end
