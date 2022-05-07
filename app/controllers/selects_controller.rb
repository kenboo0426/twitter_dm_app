# frozen_string_literal: true

class SelectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = TwitterApi::Client.new.user_search(params[:keyword], params[:count], params[:page],
                                                filter_messaged: params[:filter_messaged])
  end

  def send_message; end
end
