desc "Compute list average time"
task :compute_list_average_time => :environment do
  Board.compute_list_average_time
end
