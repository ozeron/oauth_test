class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token
  def adfs
    @user = User.find_by(email: uid)
    return failure_address_mismatch if uid != params['email'].downcase
    return failure unless @user&.persisted?
    if mobile?
      sign_in_mobile
    else
      sign_in_web
    end
  end

  def mobile?
    params['mobile'] == 'true'
  end

  def sign_in_mobile
    sign_in @user, store: false
    @token = create_user_auth_token(@user)
    @url = "CropioApp://login?#{@token.to_query}"
  end

  def sign_in_web
    sign_in_and_redirect @user, event: :authentication
    session[:logged_in_via] = 'adfs'
    return unless is_navigational_format?
    set_flash_message(:notice, :success, kind: 'Agroinvest Adfs')
  end

  def failure
    redirect_to root_path, flash: { alert: "Tried to log in with email#{uid}. #{uid} not registered in the system." }
  end

  def failure_address_mismatch
    redirect_to root_path, flash: { alert: "You entered #{params['email']} but signned in ADFS via #{uid}. Email don't match! <a href='#{iframe_path(url: ADFS_CONFIG['log_out_url'], timeout: 500)}'> Sign Out from ADFS.</a>".html_safe }
  end

  protected

  def uid
    request.env['omniauth.auth']['uid'].downcase
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
