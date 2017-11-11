require 'rest-client'
class Dealer

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
    while result.nil? and code != 405
      begin
        result = RestClient.get "https://services.comparaonline.com/dealer/deck/#{token}/deal/#{num}"
        return JSON.parse(result.body)
      rescue RestClient::ExceptionWithResponse => e
        # error = JSON.parse(e.response)
        # code = error["statusCode"]
        # error = error["error"]
        # msg = error["message"]
        # puts "#log: #{code} #{error} #{msg}"
      end 
    end
    return false
  end
end