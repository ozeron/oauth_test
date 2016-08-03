module OmniAuth
  module Strategies
    class Adfs < OmniAuth::Strategies::OAuth2
      option :name, 'adfs'

      option :client_id, 'ab762716-544d-4aeb-a526-687b73838a33'
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

      option :redirect_uri, 'http://oauth.cropio.com:3000/d/users/auth/adfs/callback'

      def callback_url
        URI(super).tap { |u| sanitize_query!(u) }.to_s
      end

      uid do
        JWT.decode(access_token.token)[0]['email']
      end

      private

      def sanitize_query!(uri)
        uri.query = sanitize_query(uri)
      end

      def sanitize_query(uri)
        Rack::Utils.parse_query(uri.query).select do |k, _|
          %w(tenant email mobile).include?(k)
        end.to_query
      end
    end
  end
end
