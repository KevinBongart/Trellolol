class MetricGroup < ActiveRecord::Base
  belongs_to :board
  has_many :metrics
end
