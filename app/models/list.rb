class List < ActiveRecord::Base
  belongs_to :board

  def self.create_from_trello_data(data, board)
    List.create(:trello_id => data['id'], :name => data['name'], :board_id => board.id)
  end

  def self.fetch_from_trello(board)
    auth = Authorization.first
    base_url = "https://api.trello.com/1/"
    tokens   = "&key=#{auth.key}&token=#{auth.token}"
    params   = "boards/#{board.trello_id}/lists?"

    uri = URI.parse(base_url + params + tokens)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)

    response
  end
end
