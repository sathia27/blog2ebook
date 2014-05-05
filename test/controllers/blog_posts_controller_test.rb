require 'test_helper'

class BlogPostsControllerTest < ActionController::TestCase
  test "should get generate_epub" do
    get :generate_epub
    assert_response :success
  end

end
