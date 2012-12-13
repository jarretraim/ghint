require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in :user, users(:valid)

    get :index
    assert_response :redirect
  end

end
