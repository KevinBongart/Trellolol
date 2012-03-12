desc "Track WIP"
task :track_wip => :environment do
  Board.track_wip
end
