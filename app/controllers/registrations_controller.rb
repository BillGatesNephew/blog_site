class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_author!, only: [:edit, :update]
    before_action :ensure_author_is_admin, only: [:new, :cancel, :destroy, :create]
    prepend_before_action :require_no_authentication, only: :cancel
    
    private 
        # Checks if current author has author creation priviledges or not 
        # TODO: Add column for admin privileges to authors table 
        def current_author_is_admin?
            current_author != nil && current_author.id == 1
        end 

        # Ensures that the author has admin privileges for the page.
        # Otherwise, redirects back to :root
        def ensure_author_is_admin
            unless current_author_is_admin?
                redirect_to :root
            end 
        end 

        # Param whitelisting for signing up
        def sign_up_params
            params.require(:author).permit(:name, :email, :password, :password_confirmation)
        end

        # Param whitelisting for updating account
        def account_update_params
            params.require(:author).permit(:name, :email, :password, :password_confirmation, :current_password)
        end
    
end 