class DeckController < ApplicationController
  def index
  	dealer = Dealer.new
  	@token = dealer.get_token
  	@flop = dealer.get_cards(@token, 5)
  	@hand_one = dealer.get_cards(@token, 2)
  	@hand_two = dealer.get_cards(@token, 2)
  end
end
