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
      call_freshmail(:get, 'ping')
    end

    def mail(mail_data = {})
      call_freshmail(:post, 'mail', mail_data)
    end

    def subscriber(sub_info = {})
      call_freshmail(:get, 'subscriber/get', sub_info)
    end

    def subscribers(sub_info = {})
      call_freshmail(:get, 'subscriber/getMultiple', sub_info)
    end

    def add_subscriber(sub_info = {})
      call_freshmail(:post, 'subscriber/add', sub_info)
    end

    def batch_add_subscriber(sub_info = {})
      call_freshmail(:post, 'subscriber/addMultiple', sub_info)
    end

    def delete_subscriber(sub_info = {})
      call_freshmail(:post, 'subscriber/delete', sub_info)
    end

    def batch_delete_subscriber(sub_info = {})
      call_freshmail(:post, 'subscriber/deleteMultiple', sub_info)
    end

    def lists
      call_freshmail(:get, 'subscribers_list/lists')
    end

    def create_list(list_info = {})
      call_freshmail(:post, 'subscribers_list/create', list_info)
    end

    def update_list(list_info = {})
      call_freshmail(:post, 'subscribers_list/update', list_info)
    end

    def delete_list(list_info = {})
      call_freshmail(:post, 'subscribers_list/delete', list_info)
    end

    protected
      def call_freshmail(call_type, get_data, json_data = nil)
        json_data_converted = json_data ? json_data.to_json : '' 
        endpoint = "/rest/#{get_data}"

        conn = Faraday.new(:url => URL) do |faraday|
          faraday.request  :url_encoded             
          faraday.response :logger                  
          faraday.adapter  Faraday.default_adapter  
        end

        response = conn.send(call_type) do |req|
          req.url endpoint
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-Rest-ApiKey'] = self.api_key
          req.headers['X-Rest-ApiSign'] = api_sign(endpoint, json_data_converted)
          if req.method == :get
            req.params = json_data if json_data
          else
            req.body = json_data_converted
          end
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