class WelcomeController < ActionController::Base
  def index
    Board.compute_list_average_time
  end
end
