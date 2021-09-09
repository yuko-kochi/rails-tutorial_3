require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    # assert_templateメソッドを使って、Homeページが正しいビューを描画しているかどうか確かめる
    # マッチするHTMLを探す
    # aタグとhref属性をオプションで指定して調べてる
    # Railsは自動的にはてなマーク "?" をabout_pathに置換する
    # リンクが２つある場合は、count: 2 とする
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")

  end
end
