class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_author!, only: [:edit, :update]
    before_action :validate_author_privileges, only: [:new, :cancel, :destroy, :create]
    prepend_before_action :require_no_authentication, only: :cancel
    private 

    def validate_author_privileges
        puts "\n\n"
        puts current_author
        puts "\n\n"
        if current_author == nil || current_author.id != 1
            redirect_to :root
        end 
    end 

    def sign_up_params
        params.require(:author).permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
        params.require(:author).permit(:name, :email, :password, :password_confirmation, :current_password)
    end
    
end 