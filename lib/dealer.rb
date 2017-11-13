require 'rest-client'
class Dealer
  CARDS = ['A','2','3','4','5','6','7','8','9','10','J','Q','K','A']
  CARDS_VALUE = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]

  def winner_hand data_hand1, data_hand2,
    hand1 = Hand.new(data_hand1)
    hand2 = Hand.new(data_hand2)

    rank1 = hand1.rank
    rank2 = hand2.rank

    if rank1.last == rank2.last
      tie = tie_break(rank1, data_hand1, data_hand2) 
      return [0,rank1.first] if tie == 0
      return tie == 1 ? [1,rank1.first] : [2,rank2.first]
    else
      return rank1.last > rank2.last ? [1,rank1.first] : [2,rank2.first]
    end
  end

  def tie_break rank, hand1, hand2
    if rank.last == 0
       tie_high_card hand1, hand2
    else
      begin
        send("tie_#{rank.first.to_s}",hand1,hand2)
      rescue
        return 0
      end
    end
  end

  def tie_pair hand1, hand2
    numbers1 = hand1.get_numbers
    numbers2 = hand2.get_numbers
    high1 = numbers1.group_by {|e| e}.map { |e| e[0] if e[1][1]}.compact.map{|e| CARDS[1..-1].index(e)}.sort.reverse.first
    high2 = numbers2.group_by {|e| e}.map { |e| e[0] if e[1][1]}.compact.map{|e| CARDS[1..-1].index(e)}.sort.reverse.first
    high1 > high2 ? 1 : 2
  end

  # def tie_two_pair hand1, hand2
  # end

  # def tie_three_of_a_kind hand1, hand2
  # end

  # def tie_straight hand1, hand2
  # end

  # def tie_flush hand1, hand2
  # end

  # def tie_full_house hand1, hand2
  # end

  # def tie_four_of_a_kind hand1, hand2
  # end

  # def tie_straight_flush hand1, hand2
  # end

  # def tie_royal_flush hand1, hand2
  # end

  def tie_high_card hand1, hand2
    numbers1 = hand1.map{|h| CARDS_VALUE[CARDS[1..-1].index(h["number"])] }.sort.reverse
    numbers2 = hand2.map{|h| CARDS_VALUE[CARDS[1..-1].index(h["number"])] }.sort.reverse
    0.upto(4) do |i|
      next if numbers1[i] == numbers2[i]
      return (numbers1[i] > numbers2[i] ? 1 : 2)
    end
    return 0
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

end