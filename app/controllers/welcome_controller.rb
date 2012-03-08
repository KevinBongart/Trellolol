class WelcomeController < ActionController::Base
  def index
    @lists = {}
    List.all.each do |list|
      @lists[list.id] = { :total_time => 0, :count => 0 }
    end
  end
end
