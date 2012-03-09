class WelcomeController < ActionController::Base
  def index
    redirect_to authorizations_path unless Authorization.first
    Board.compute_list_average_time
  end
end
