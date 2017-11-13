class Card
  attr_reader :suit, :number, :value
  SUITS = {
    :diamonds => "diamonds",
    :hearts => "hearts",
    :spades => "spades",
    :clubs => "clubs"
  }.freeze

  CARDS_VALUES = {
    '2' => 1,
    '3' => 2,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 7,
    '9' => 8,
    '10' => 9,
    'J' => 10,
    'Q' => 11,
    'K' => 12,
    'A' => 13
  }.freeze

  def initialize(suit, number)
    @suit = suit
    @number = number
    @value = CARDS_VALUES[number]
  end

  SUITS.each do |suit, name|
      define_method "is_#{name}?" do
          self.suit == @suit
      end
  end


end