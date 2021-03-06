require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    assert_select 'li', "Password confirmation doesn't match Password"
  end

  test 'valid user signup' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Valid User',
                                         email: 'user@valid.org',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
    assert is_logged_in?
  end
end
