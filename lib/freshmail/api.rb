module Freshmail
  class Api
    attr_accessor :api_key, :api_secret

    URL = 'https://app.freshmail.pl'

    def initialize(api_key, api_secret)
      @api_key = api_key || self.class.api_key || ENV['FRESHMAIL_API_KEY']
      @api_key = @api_key.strip if @api_key
      @api_secret = api_secret || self.class.api_secret || ENV['FRESHMAIL_API_secret']
      @api_secret = @api_secret.strip if @api_secret

      raise Freshmail::CredentialsMissingError, 'api_key or api_secret are missing' unless @api_secret or @api_key
      raise Freshmail::CredentialsInvalidError, 'api_key or api_secret are invalid' unless self.ping['data'] == 'pong'
    end

    def ping
      call_freshmail('ping')
    end

    protected
      def call_freshmail(get_data, json_data = nil)
        json_data_converted = json_data ? json_data.to_json : '' 
        endpoint = "/rest/#{get_data}"

        conn = Faraday.new(:url => URL) do |faraday|
          faraday.request  :url_encoded             
          # faraday.response :logger                  
          faraday.adapter  Faraday.default_adapter  
        end

        response = conn.get do |req|
          req.url endpoint
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-Rest-ApiKey'] = self.api_key
          req.headers['X-Rest-ApiSign'] = api_sign(endpoint, json_data_converted)
          req.params = json_data if json_data
        end

        JSON.parse(response.body)
      end

      def api_sign(get_data, json_data)
        Digest::SHA1.hexdigest [
          self.api_key,
          get_data,
          json_data,
          self.api_secret
        ].join
      end
  end
end