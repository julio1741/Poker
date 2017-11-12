class DeckController < ApplicationController
  def index
  	dealer = Dealer.new
  	@token = dealer.get_token
  	@hand_one = dealer.get_cards(@token, 5)
  	@hand_two = dealer.get_cards(@token, 5)
  end
end
