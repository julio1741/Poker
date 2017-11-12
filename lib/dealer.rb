require 'rest-client'
class Dealer
  CARDS = ['A','1','2','3','4','5','6','7','8','9','10','J','Q','K','A']
  CARDS_VALUE = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
  STRAIGHTS = CARDS.each_cons(5).map(&:to_a)
 
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

  def winner_hand hand1, hand2,
    rank1 = rank(hand1)
    rank2 = rank(hand2)
    rank1.last > rank2.last ? [1,rank1.first] : [2,rank2.first]
  end

  def rank hand
    RANKS.detect { |method, rank| send("#{method}?", hand) } || [:high_card, 0]
  end

  def get_token
    result = nil

    while result.nil?
      begin
        result = RestClient.post 'https://services.comparaonline.com/dealer/deck',{}
      rescue RestClient::ExceptionWithResponse => e
        puts JSON.parse(e.response)
      end  
    end
    result.body
  end

  def get_cards token, num
    result = nil
    code = 0
    while result.nil? and code != 405 and code != 404
      begin
        result = RestClient.get "https://services.comparaonline.com/dealer/deck/#{token}/deal/#{num}"
        return JSON.parse(result.body)
      rescue RestClient::ExceptionWithResponse => e
        begin
          error = JSON.parse(e.response)
          code = error["statusCode"]
          error = error["error"]
          msg = error["message"]
          puts "#log: #{code} #{error} #{msg}"
        rescue
          puts "Json response problem"
        end
      end 
    end
    return code
  end

  def high_card hand
    numbers = hand.map{|h| h["number"]}
    max_index = numbers.map{|n| CARDS[1..-1].index(n)}.max
    CARDS[1..-1][max_index]
  end

  def pair? hand
    numbers = hand.map{|h| h["number"]}
    not numbers.size == numbers.uniq.size
  end

  def two_pair? hand
    numbers = hand.map{|h| h["number"]}
    repeated = numbers.group_by {|e| e}.map { |e| e[0] if e[1][1]}.compact
    repeated.size == 2
  end

  def three_of_a_kind? hand
    numbers = hand.map{|h| h["number"]}
    freq = numbers.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max_freq = freq.to_a.max_by(&:last)
    max_freq.last == 3
  end

  def straight? hand
    numbers = hand.map{|h| h["number"]}.map(&:to_s)
    get_straight.include? numbers
  end

  def flush? hand
    suits = hand.map{|h| h["suit"]}
    suits.uniq.count == 1
  end

  def full_house? hand #fix
    pair?(hand) and three_of_a_kind?(hand)
  end

  def four_of_a_kind? hand
    numbers = hand.map{|h| h["number"]}
    freq = numbers.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max_freq = freq.to_a.max_by(&:last)
    max_freq.last == 4
  end

  def straight_flush? hand
    straight?(hand) and flush?(hand)
  end

  def royal_flush? hand 
    numbers = hand.map{|h| h["number"]}.map(&:to_s)
    numbers.sort == STRAIGHTS.last.sort and flush?
  end

  def get_straight
    STRAIGHTS
  end
  
  def get_card_numbers
    CARDS
  end

end