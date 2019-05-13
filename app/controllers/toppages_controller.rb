class ToppagesController < ApplicationController
  def index
  end
  CONSUMER_KEY = '2d24cd94556f0e219f361bb5df5bb49d7b381d93'
  CONSUMER_SECRET = 'dc3b12ee9632e54efd360ba4213bd79d39e077f4'
  CALLBACK_URL = 'http://192.168.0.2/callback'
  #CALLBACK_URL = 'http://google.com/'
  API_URL = 'https://api.zaim.net/v2/'

  def top
  end

  def login
    set_consumer
    @request_token = @consumer.get_request_token(oauth_callback: CALLBACK_URL)
#     session[:request_token] = @request_token.token
#     session[:request_secret] = @request_token.secret
    store(:req_tok, @request_token.token)
    store(:req_sec, @request_token.secret)
    redirect_to @request_token.authorize_url(:oauth_callback => CALLBACK_URL)
  end

  def callback
    if restore(:req_tok) && params[:oauth_verifier]
      set_consumer
      @oauth_verifier = params[:oauth_verifier]
      @request_token = OAuth::RequestToken.new(@consumer, restore(:req_tok), restore(:req_sec))
      access_token = @request_token.get_access_token(:oauth_verifier => @oauth_verifier)
      store(:acc_tok, access_token.token)
      store(:acc_sec, access_token.secret)
      redirect_to money_path
    else
      logout
    end
  end

  def money
    set_consumer
    @access_token = OAuth::AccessToken.new(@consumer, restore(:acc_tok), restore(:acc_sec))
    money = @access_token.get("#{API_URL}home/money")
    @money = JSON.parse(money.body)
  end

  def logout
    session[:request_token] = nil
    session[:access_token] = nil
    redirect_to '/zaimauth'
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
