require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Bookworm"
  end

  # test "should get root" do
  #   get root_path
  #   assert_response :success
  # end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "ホーム / #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "アプリ詳細 / #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "お問い合わせ / #{@base_title}"
  end
end