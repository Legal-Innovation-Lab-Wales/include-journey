require 'controllers/controller_test'

class PagesControllerTest < ControllerTest
  test "logged-out user can view Terms page" do
    get terms_path
    assert_response :success
  end
  
  test "logged-out user can view Privacy Notice page" do
    get privacy_notice_path
    assert_response :success
  end

  test "logged-out user can view Cookie Policy page" do
    get cookie_policy_path
    assert_response :success
  end
end
