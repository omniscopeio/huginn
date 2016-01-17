class SslVerificationController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    render text: ENV["SSL_VERIFICATION_KEY"]
  end
end