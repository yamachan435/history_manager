module Zaim

  class ZaimAuthController < ApplicationController
  end

  module Zaim
    def transfer
      accessor = ApiAccessor.new(user)
      response = accessor.access(:post, "home/money/transfer", to_zaim)
      return JSON.parse(response)
    end

    def payment
      accessor = ApiAccessor.new(user)
      response = accessor.access(:post, "home/money/payment", to_zaim)
      return JSON.parse(response)
    end

    def delete(kind)
      accessor = ApiAccessor.new(user)
      response = accessor.access(:delete, "home/money/#{kind}/#{zaim_id}")
      return JSON.parse(response)
    end
  end

  class ApiAccessor
    CONSUMER_KEY = APP_CONFIG['zaim']['consumer_key']
    CONSUMER_SECRET = APP_CONFIG['zaim']['consumer_secret']
    CALLBACK_URL = 'http://192.168.0.2/callback'
    API_URL = 'https://api.zaim.net/v2/'

    def initialize(user)
      @zaim_user = user.zaim_user
      @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
        site: 'https://api.zaim.net',
        request_token_path: '/v2/auth/request',
        authorize_url: 'https://auth.zaim.net/users/auth',
        access_token_path: '/v2/auth/access')
    end

    def access(method, path, body = nil)
      Rails.logger.info path.inspect
      Rails.logger.info body.inspect if body
      Rails.logger.info @zaim_user.inspect
      @access_token = OAuth::AccessToken.new(@consumer, @zaim_user.access_token, @zaim_user.access_token_secret)

      if APP_CONFIG['zaim_access']
        url = API_URL + path
      else
        url = 'http://localhost/'
      end

      if body
        res = @access_token.send(method, url, body)
      else
        res = @access_token.send(method, url)
      end
      Rails.logger.info res.body.inspect
      return res.body
    end
  end
end

