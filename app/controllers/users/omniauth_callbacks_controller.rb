class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  #skip_before_filter :verify_authenticity_token

  # You should also create an action method in this controller like this:
  # def twitter
  # end
    def adfs
      @user = User.find_by_email(request.env["omniauth.auth"]['uid'].downcase)
      if @user.present? && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Agroinvest Adfs') if is_navigational_format?
      else 
        failure
      end
    end

    def failure
      redirect_to root_path
    end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end