class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  #skip_before_filter :verify_authenticity_token

  # You should also create an action method in this controller like this:
  # def twitter
  # end
    def adfs
      @user = User.find_by_email()
      if @user.present? && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Agroinvest Adfs') if is_navigational_format?
      else
        failure
      end
    end

    def adfs_mobile
      @user = User.find_by(email: uid)
      return failure_address_mismatch if uid != params['email'].downcase
      if @user&.persisted?
        response.headers['X-User-Api-Token'] = create_user_auth_token(@user)
        render plain: "OK"
      else
        failure
      end
    end

    def failure
      # set_flash_message(:error, :f, kind: 'Agroinvest Adfs') if is_navigational_format?
      flash.now[:error] = "Tryed to log in with email#{uid}. #{uid} not registered in the system."
      redirect_to root_path
    end

    protected

    def uid
      request.env["omniauth.auth"]['uid'].downcase
    end

    def create_user_auth_token(user)
    user.create_user_auth_token!(device_info_from_user_agent)
  end

  def device_info_from_user_agent
    user_agent = request.env['HTTP_USER_AGENT']
    client = DeviceDetector.new(user_agent)

    {
      name: client.name,
      full_version: client.full_version,
      os_name: client.os_name,
      os_full_version: client.os_full_version,
      device_name: client.device_name,
      device_type: client.device_type
    }
  end
end
