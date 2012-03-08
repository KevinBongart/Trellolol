class Action < ActiveRecord::Base
  belongs_to :card

  default_scope order('date ASC')

  def list_created_in
    List.find_by_trello_id(self.list_trello_id)
  end

  def list_before
    List.find_by_trello_id(self.list_before_trello_id)
  end

  def list_after
    List.find_by_trello_id(self.list_after_trello_id)
  end

  def self.create_from_trello_data(data, card)
     if data['type'] == 'createCard'
      Action.create(
        :trello_id => data['id'],
        :card_id => card.id,
        :list_trello_id => data['data']['list']['id'],
        :date => data['date'].to_time
      )
    elsif (data['data']['listBefore'] && data['data']['listBefore'])
      Action.create(
        :trello_id => data['id'],
        :card_id => card.id,
        :list_before_trello_id => data['data']['listBefore']['id'],
        :list_after_trello_id => data['data']['listAfter']['id'],
        :date => data['date'].to_time
      )
    end
  end

  def self.fetch_from_trello(card)
    auth = Authorization.first
    base_url = "https://api.trello.com/1/"
    tokens   = "&key=#{auth.key}&token=#{auth.token}"
    params   = "cards/#{card.trello_id}/actions?filter=updateCard,createCard&limit=1000"

    uri = URI.parse(base_url + params + tokens)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)

    response
  end
end
