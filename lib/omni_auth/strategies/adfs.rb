module OmniAuth
  module Strategies
    class Adfs < OmniAuth::Strategies::OAuth2
      option :name, 'adfs'

      option :client_id, 'ab172737-444a-4abc-a556-687b73838a88'
      option :provider_ignores_state, true
      option :authorize_params,
             {
               response_type: 'code',
               resource: 'http://oauth.cropio.com:3000'
             }
      option :client_options,
             {
               site: 'https://adfs.agroinvest.com',
               authorize_url: 'adfs/oauth2/authorize',
               token_url: 'adfs/oauth2/token'
             }

      option :token_options, [:redirect_uri]

      option :redirect_uri, 'http://oauth.cropio.com:3000/users/auth/adfs/callback'

      def callback_phase
        byebug
        super
      end

      uid do
         JWT.decode(access_token.token, nil, false)[0]['email']
      end
    end
  end
end
