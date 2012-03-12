class Board < ActiveRecord::Base
  require "net/https"
  require "uri"

  has_many :lists
  has_many :metric_groups

  def self.create_from_trello_data(data)
    Board.create(:trello_id => data['id'], :name => data['name']) unless data['name'] == 'Welcome Board'
  end

  def self.fetch_from_trello
    auth = Authorization.first
    base_url = "https://api.trello.com/1/"
    tokens   = "&key=#{auth.key}&token=#{auth.token}"
    params   = "members/me?boards=open"

    uri = URI.parse(base_url + params + tokens)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)

    response['boards']
  end

  def self.compute_list_average_time
    lists = {}
    List.all.each do |list|
      lists[list.id] = { :total_time => 0, :count => 0 }
    end

    Card.all.each do |card|
      previous_action = nil
      card.actions.each do |action|
        if previous_action && action.list_before
          time = action.date - previous_action.date
          lists[action.list_before.id][:total_time] += time.to_i
          lists[action.list_before.id][:count]      += 1
        end
        previous_action = action
      end
    end

    List.all.each do |list|
      list.update_attributes(:total_time => lists[list.id][:total_time], :count => lists[list.id][:count])
    end
  end

  def self.track_wip
    Board.all.each do |board|
      group = MetricGroup.create!(:board => board)
      board.lists.each do |list|
        auth = Authorization.first
        base_url = "https://api.trello.com/1/"
        tokens   = "&key=#{auth.key}&token=#{auth.token}"
        params   = "lists/#{list.trello_id}/cards?"

        uri = URI.parse(base_url + params + tokens)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = JSON.parse(http.request(request).body)
        cards_count = response.count #NIKKI

        Metric.create!(:metric_group => group, :list => list, :cards_count => cards_count)
      end
    end
  end
end
