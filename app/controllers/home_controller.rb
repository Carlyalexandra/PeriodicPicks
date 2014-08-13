require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'hashie'

class HomeController < ApplicationController


 

  def index
  	q = params[:q].to_s
  	@main = Youtube.new.main(q)

  	gr_key=ENV["GOODREADS_KEY"] 

	client = Goodreads.new(:api_key => gr_key)
	@search = client.search_books(q)
  end

  def show
  end





end
