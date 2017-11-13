class DeckController < ApplicationController
  def index
    dealer = Dealer.new
    @token = dealer.get_token
    @hand_one = dealer.get_cards(@token, 5)
    @hand_two = dealer.get_cards(@token, 5)
    @out_of_hands = "Session Deck Expired!" if  @hand_one == 404 or @hand_two == 404
    unless @out_of_hands
      winner = dealer.winner_hand(@hand_one, @hand_two)
      @winner_hand = winner.first
      @winner_hand_name = winner.last
    end
  end

  def new_hands
    dealer = Dealer.new
    @token = params[:token]
    @hand_one = dealer.get_cards(@token, 5)
    @hand_two = dealer.get_cards(@token, 5)
    @out_of_hands = "Session Deck Expired!" if  @hand_one == 404 or @hand_two == 404
    @out_of_hands = "Out of Hands!" if  @hand_one == 405 or @hand_two == 405
    unless @out_of_hands
      winner = dealer.winner_hand(@hand_one, @hand_two)
      @winner_hand = winner.first
      @winner_hand_name = winner.last
    end
    render 'index'
  end

end
