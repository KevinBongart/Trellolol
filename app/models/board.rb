class Board < ActiveRecord::Base
  has_many :lists

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
end
