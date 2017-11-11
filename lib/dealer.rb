require 'rest-client'
class Dealer

  def get_token
    result = nil

    while result.nil?
      begin
        result = RestClient.post 'https://services.comparaonline.com/dealer/deck',{}
      rescue
        result = nil
      end  
    end
    result.body
  end

  def get_cards token, num
    result = nil
    while result.nil?
      begin
        result = RestClient.get "https://services.comparaonline.com/dealer/deck/#{token}/deal/#{num}"
      rescue
        result = nil
      end  
    end
    JSON.parse(result.body)
  end
end