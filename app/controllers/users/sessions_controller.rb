class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def setup
    strategy = request.env['omniauth.strategy']
    return unless strategy
    if params['email'].present?
      strategy.options.authorize_params.username = params['email']
    end
    strategy.options.authorize_params.resource = request.base_url
    render text: 'Omniauth setup phase.', status: 404
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
