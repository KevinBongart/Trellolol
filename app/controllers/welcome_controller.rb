class WelcomeController < ApplicationController
  def index
    redirect_to authorizations_path unless Authorization.first

    @data = {}
    Board.all.each do |board|
      @data[board.id] = { 'categories' => [], 'series' => [] }
      @data[board.id]['categories'] = board.metric_groups.map { |group| group.created_at.to_date }
      completed_counts = []
      longest_array_size = 0
      add_completed = false

      board.lists.each do |list|
        if list.name.downcase.match('completed')
          add_completed = true
          count = list.metrics.map(&:cards_count)
          completed_counts << count
          longest_array_size = count.size if count.size > longest_array_size
        else
          @data[board.id]['series'] << { 'name' => list.name, 'data' => list.metrics.map(&:cards_count) }
        end
      end

      if add_completed
        completed = Array.new(longest_array_size, 0)
        completed_counts.each do |array|
          completed = [Array.new(longest_array_size - array.size, 0) + array, completed].transpose.map {|x| x.reduce(:+)}
        end
        @data[board.id]['series'] << { 'name' => 'Completed', 'data' => completed }
      end
    end
  end
end
