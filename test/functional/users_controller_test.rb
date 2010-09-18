#require 'test_helper'
require File.expand_path('../../test_helper', __FILE__)

class UsersControllerTest < ActionController::TestCase
  
  setup do
    @user = users(:valid_user)
  end

# Test to check that the index page is loaded.
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

# Test to create a new user
  test "should get new" do
    get :new
    title = assigns(:title)
    assert_equal "Register", title
    assert_response :success
    assert_template "new"
    
    # Test that form and all its tags
    assert_tag "form", :attributes => { :action => "/users", :method => "post"}
    
    assert_tag "input", :attributes => {  :name => "user[first_name]",
                                          :type => "text",
                                          :size => User::FIRST_NAME_SIZE,
                                          :maxlength => User::FIRST_NAME_MAX_LENGTH 
                                        }
                                        
    assert_tag "input", :attributes => {  :name => "user[last_name]",
                                          :type => "text",
                                          :size => User::LAST_NAME_SIZE,
                                          :maxlength => User::LAST_NAME_MAX_LENGTH 
                                        }  
                                            
    assert_tag "input", :attributes => {  :name => "user[email]",
                                          :type => "text",
                                          :size => User::EMAIL_SIZE,
                                          :maxlength => User::EMAIL_MAX_LENGTH 
                                        }                              
    assert_tag "input", :attributes => {  :name => "user[password]",
                                          :type => "password",
                                          :size => User::PASSWORD_SIZE,
                                          :maxlength => User::PASSWORD_MAX_LENGTH 
                                        } 
    assert_tag "input", :attributes => { :type => "submit", :value => "Register!"}
  end


# Test to check that a user is created.
  test "should create user" do
    assert_difference('User.count') do
    post :create, :user => {  :first_name => "new_first_name",
                                :last_name => "new_last_name",
                                :email => "new_email@email.com",
                                :password => "new_password"
                              }
                              
    # Test assignment of user.
    user = assigns(:user)
    assert_not_nil user
    # Test new uer in database
    new_user = User.find_by_first_name_and_password(user.first_name, user.password)
    assert_equal new_user, user
    # Test flash and redirect
    assert_equal "User #{user.first_name} was successfully created.", flash[:notice]
    assert_redirected_to user_path(assigns(:user))
  
    end
  end
  
  test "should fail create user" do
    post :create, :user => {  :first_name => "xx/ fsaaa",
                                :last_name => "fff-_/ sSS",
                                :email => "new_email@email,com",
                                :password => "new"
                              }
                              
    assert_response :success
    assert_template "new"
    # Test display of error messages
    assert_tag "div", :attributes => {:id => "errorExplanation"}                                  
    # Assert that each form field has at least on error
    assert_tag "li", :content => /First name/
    assert_tag "li", :content => /Last name/
    assert_tag "li", :content => /Email/
    assert_tag "li", :content => /Password/
    
    # Test to see if insert fields are being wrapped with the correct div.
    error_div = { :tag => "div", :attributes => { :class => "field_with_errors"} }
    assert_tag "input", :attributes => {  :name => "user[first_name]",
                                          :value => "xx/ fsaaa"
    },                  :parent => error_div
    assert_tag "input", :attributes => {  :name => "user[last_name]",
                                          :value => "fff-_/ sSS"
    },                  :parent => error_div
    assert_tag "input", :attributes => {  :name => "user[email]",
                                          :value => "new_email@email,com"
    },                  :parent => error_div
    assert_tag "input", :attributes => {  :name => "user[password]",
                                          :value => "new"
    },                  :parent => error_div
  
  end
  
  


#  test "should show user" do
#    get :show, :id => @user.to_param
#    assert_response :success
#  end

#  test "should get edit" do
#    get :edit, :id => @user.to_param
#    assert_response :success
#  end

#  test "should update user" do
#    put :update, :id => @user.to_param, :user => @user.attributes
#    assert_redirected_to user_path(assigns(:user))
#  end

#  test "should destroy user" do
#    assert_difference('User.count', -1) do
#      delete :destroy, :id => @user.to_param
#    end

#    assert_redirected_to users_path
#  end
end
