require 'test_helper'

class DeckControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
