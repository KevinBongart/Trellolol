class Card < ActiveRecord::Base
  has_many :actions

  default_scope order('trello_id ASC')

  def self.create_from_trello_data(data)
    Card.create(:trello_id => data['id'], :name => data['name'])
  end

  def self.fetch_from_trello(board)
    auth = Authorization.first
    base_url = "https://api.trello.com/1/"
    tokens   = "&key=#{auth.key}&token=#{auth.token}"
    params   = "boards/#{board.trello_id}/cards?"

    uri = URI.parse(base_url + params + tokens)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)

    response
  end

  def completed?
    self.actions.last.list_after && self.actions.last.list_after.name.match('Completed')
  end

  def time_to_completion
    return unless completed?
    self.actions.first.date - self.actions.last.date
  end
end
