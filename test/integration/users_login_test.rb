require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:tanaka)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    # リダイレクト先が正しいかどうかをチェック
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # ログインパスのリンクがページにないかどうかで判定
    # count: 0というオプションをassert_selectに追加すると、渡したパターンに一致するリンクが０かどうかを確認できる
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

end
