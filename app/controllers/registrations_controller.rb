class RegistrationsController < Devise::RegistrationsController
    # Insert a Profile record after signing up successfully
    def create
      super do |user|
        if user.persisted?
        # Create profile only if the user is successfully saved
        Profile.create(user_id: user.id)
        end
      end
    end

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
