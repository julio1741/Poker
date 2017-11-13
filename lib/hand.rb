class Hand
  attr_reader :cards

  STRAIGHTS = ['A'] + Card::CARDS_VALUES.map(&:first).each_cons(5).map(&:to_a)

  RANKS = {
    royal_flush:     9,
    straight_flush:  8,
    four_of_a_kind:  7,
    full_house:      6,
    flush:           5,
    straight:        4,
    three_of_a_kind: 3,
    two_pair:        2,
    pair:            1
  }.freeze
  
  def initialize array
    @cards = array.map{|data| Card.new(data["suit"],data["number"])}
  end

  def rank
    RANKS.detect { |method, rank| send("#{method}?") } || [:high_card, 0]
  end

  def high_card
    numbers = get_numbers
    max_index = numbers.map{|n| Card::CARDS_VALUES.map(&:first).index(n)}.max
    Card::CARDS_VALUES.map(&:first)[max_index]
  end

  def pair?
    numbers = get_numbers
    not numbers.size == numbers.uniq.size
  end

  def two_pair?
    numbers = get_numbers
    repeated = numbers.group_by {|e| e}.map { |e| e[0] if e[1][1]}.compact
    repeated.size == 2
  end

  def three_of_a_kind?
    numbers = get_numbers
    freq = numbers.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max_freq = freq.to_a.max_by(&:last)
    max_freq.last == 3
  end

  def straight?
    numbers = get_numbers_sorted
    get_straight.include? numbers
  end

  def flush?
    suits = get_suits
    suits.uniq.count == 1
  end

  def full_house?
    numbers = get_numbers
    freq = numbers.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    freq_array = freq.to_a
    sorted = freq_array.sort {|a,b| a[1] <=> b[1]}
    a = sorted.pop.last
    b = sorted.pop.last
    a == 3 and b == 2 
  end

  def four_of_a_kind? 
    numbers = get_numbers
    freq = numbers.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max_freq = freq.to_a.max_by(&:last)
    max_freq.last == 4
  end

  def straight_flush?
    straight? and flush?
  end

  def royal_flush? 
    numbers = get_numbers
    numbers.sort == STRAIGHTS.last.sort and flush?
  end

  def get_straight
    STRAIGHTS
  end

  #private

    def get_numbers
      @cards.map{|c| c.number}
    end

    def get_suits
      @cards.map{|c| c.suit}
    end

    def get_numbers_sorted
      values = get_numbers.map{|v| Card::CARDS_VALUES[v]  }
      sorted = values.sort.map{|v| Card::CARDS_VALUES.key(v)  }
      sorted
    end

end