class DeckController < ApplicationController
  def index
  	dealer = Dealer.new
  	@token = dealer.get_token
  end
end
