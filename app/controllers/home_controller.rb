class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @gh_vars = {
        :client_id => ENV['GH_CLIENT_ID'],
        :redirect_uri => "http://localhost:3000/redirect",
        :scope => "user",
        :state => SecureRandom.uuid
    }

    @gh_uri = "https://github.com/login/oauth/authorize?" + @gh_vars.to_query
  end

  def redirect
    response = RestClient.post 'https://github.com/login/oauth/access_token',
                    {:client_id => ENV['GH_CLIENT_ID'],
                    :client_secret => ENV['GH_CLIENT_SECRET'],
                    :code => params[:code], :state => params[:state]},
                    :accept => :json


    logger.debug response.to_s


    redirect_to root_url
  end
end
