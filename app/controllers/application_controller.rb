class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #redirect to challenge git gist
  def shorty
    redirect_to "https://gist.github.com/vasc/37f36488fc9e959dcaf8"
  end
end
