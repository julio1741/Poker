class DeckController < ApplicationController
  def index
  	dealer = Dealer.new
  	@token = dealer.get_token
  	@hand_one = dealer.get_cards(@token, 5)
  	@hand_two = dealer.get_cards(@token, 5)
   	winner = dealer.winner_hand(@hand_one, @hand_two)
  	@winner_hand = winner.first
  	@winner_hand_name = winner.last
  end

end
