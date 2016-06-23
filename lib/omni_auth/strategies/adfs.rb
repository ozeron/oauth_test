module OmniAuth
  module Strategies
    class Adfs < OmniAuth::Strategies::OAuth2
      option :name, 'adfs'

      option :client_id, 'ab172737-444a-4abc-a556-687b73838a88'
      option :provider_ignores_state, true
      option :authorize_params,
             {
               response_type: 'code',
               resource: 'https://oauth.cropio.com'
             }
      option :client_options,
             {
               site: 'https://adfs.agroinvest.com',
               authorize_url: 'adfs/oauth2/authorize'
             }
    end
  end
end
