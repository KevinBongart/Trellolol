class Metric < ActiveRecord::Base
  belongs_to :metric_group
  belongs_to :list
end
