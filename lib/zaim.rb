module Zaim
  CONSUMER_KEY = '2d24cd94556f0e219f361bb5df5bb49d7b381d93'
  CONSUMER_SECRET = 'dc3b12ee9632e54efd360ba4213bd79d39e077f4'
  CALLBACK_URL = 'http://192.168.0.2/callback'
  API_URL = 'https://api.zaim.net/v2/'

  class ZaimAuthController < ApplicationController
  end

  module Zaim
    def transfer
      set_consumer
      @access_token = OAuth::AccessToken.new(@consumer, restore(:acc_tok), restore(:acc_sec))
      Rails.logger.info to_zaim
      res = @access_token.post("#{API_URL}home/money/transfer", to_zaim)
      Rails.logger.info res.body.inspect
      return JSON.parse(res.body)
    end

    def payment
      set_consumer
      @access_token = OAuth::AccessToken.new(@consumer, restore(:acc_tok), restore(:acc_sec))
      Rails.logger.info to_zaim
      res = @access_token.post("#{API_URL}home/money/payment", to_zaim)
      Rails.logger.info res.body.inspect
      return JSON.parse(res.body)
    end

    def delete(kind)
      set_consumer
      @access_token = OAuth::AccessToken.new(@consumer, restore(:acc_tok), restore(:acc_sec))
      Rails.logger.info zaim_id.inspect
      res = @access_token.delete("#{API_URL}home/money/#{kind}/#{zaim_id}")
      Rails.logger.info res.body.inspect
      return JSON.parse(res.body)
    end

    private
    def set_consumer
      @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
        site: 'https://api.zaim.net',
        request_token_path: '/v2/auth/request',
        authorize_url: 'https://auth.zaim.net/users/auth',
        access_token_path: '/v2/auth/access')
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

  module Common
    def set_consumer
      @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
        site: 'https://api.zaim.net',
        request_token_path: '/v2/auth/request',
        authorize_url: 'https://auth.zaim.net/users/auth',
        access_token_path: '/v2/auth/access')
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

