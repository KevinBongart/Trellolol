desc "Import data from your Trello account"
task :import => :environment do
  require "net/https"
  require "uri"

  Board.fetch_from_trello.each do |b|
    if board = Board.find_by_trello_id(b['id'])
      p "Board #{b['id']}: found"
    else
      board = Board.create_from_trello_data(b)
      p "Board #{b['id']}: created" if board
    end
  end

  Board.all.each do |board|
    List.fetch_from_trello(board).each do |l|
      if list = List.find_by_trello_id(l['id'])
        p "List #{l['id']}: found"
      else
        List.create_from_trello_data(l, board)
        p "List #{l['id']}: created"
      end
    end

    Card.fetch_from_trello(board).each do |c|
      card = Card.find_by_trello_id(c['id'])
      if card
        p "Card #{c['id']}: found"
      else
        card = Card.create_from_trello_data(c)
        p "Card #{c['id']}: created"
      end

      Action.fetch_from_trello(card).each do |a|
        if action = Action.find_by_trello_id(a['id'])
          p "  Action #{a['id']}: found"
        else
          action = Action.create_from_trello_data(a, card)
          p "  Action #{a['id']}: created" if action
        end
      end
    end
  end
end
