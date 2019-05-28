module Zaim

  class ZaimAuthController < ApplicationController
  end

  module Zaim
    def transfer
      accessor = ApiAccessor.new
      response = accessor.access(:post, "home/money/transfer", to_zaim)
      return JSON.parse(response)
    end

    def payment
      accessor = ApiAccessor.new
      response = accessor.access(:post, "home/money/payment", to_zaim)
      return JSON.parse(response)
    end

    def delete(kind)
      accessor = ApiAccessor.new
      response = accessor.access(:delete, "home/money/#{kind}/#{zaim_id}")
      return JSON.parse(response)
    end
  end

  class ApiAccessor
    CONSUMER_KEY = APP_CONFIG['zaim']['consumer_key']
    CONSUMER_SECRET = APP_CONFIG['zaim']['consumer_secret']
    CALLBACK_URL = 'http://192.168.0.2/callback'
    API_URL = 'https://api.zaim.net/v2/'

    def initialize
      @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
        site: 'https://api.zaim.net',
        request_token_path: '/v2/auth/request',
        authorize_url: 'https://auth.zaim.net/users/auth',
        access_token_path: '/v2/auth/access')
    end

    def access(method, path, body = nil)
      Rails.logger.info path.inspect
      Rails.logger.info body.inspect if body
      @access_token = OAuth::AccessToken.new(@consumer, restore(:acc_tok), restore(:acc_sec))

      raise unless APP_CONFIG['zaim_access']
      
      url = API_URL + path
      if body
        res = @access_token.send(method, url, body)
      else
        res = @access_token.send(method, url)
      end
      Rails.logger.info res.body.inspect
      return res.body
    end

    def store(key, value)
      File.open("tmp/tokens/#{key}", 'w') do |f|
        f.puts value
      end
    end

    def restore(key)
      begin
        File.open("tmp/tokens/#{key}", 'r') do |f|
          return f.gets.chomp
        end
      rescue
        return false
      end
    end
  end
end

