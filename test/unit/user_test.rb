#require 'test_helper'
require File.expand_path('../../test_helper', __FILE__)

class UserTest < ActiveSupport::TestCase
  fixtures :users
  
  def setup
    @error_messages = ActiveModel::Errors
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end
  
  # This user should be valid by construction
  test "test user validity" do
    assert @valid_user.valid?
  end
  
  # This user should be invalid by construction
  test "user invalidity" do
    assert !@invalid_user.valid?
    attributes = [:first_name, :last_name, :email, :password]
    attributes.each do |attribute|
      assert @invalid_user.errors(attribute).any?
    end
  end

# One test that checks the uniqueness of email.  
  test "email is unique" do
    user_repeat = User.new( :email => @valid_user.email)
    assert !user_repeat.valid?
    assert_equal @error_messages[:taken], user_repeat.errors(:email)
  end
  
# Make sure first_name cannot be too short.
  test "first_name minimum length" do
    user = @valid_user
    min_length = User::FIRST_NAME_MIN_LENGTH
    
    # First name is too short
    user.first_name = "a" * (min_length -1)
    assert !user.valid?, "#{user.first_name} should raise a minimum length error"
    
    # Format the error message based on minimum length
    correct_error_message = sprintf(@error_messages[:too_short], min_length)
    assert_equal correct_error_message, user.errors(:first_name)
    
    # First name is minimum length
    user.first_name = "a" * min_length
    assert user.valid?, "#{user.first_name} should be just long enough to pass"
    
  end
  
# Make sure the First name cannot be too long.
  test "first name maximum length" do
    user = @valid_user
    max_length = User::FIRST_NAME_MAX_LENGTH
    
    # First name is too long
    user.first_name = "a" * (max_length +1)
    assert !user.valid?, "#{user.first_name} should raise a maximum length error"
    # Format the error message based on maximum length
    correct_error_message = sprintf(@error_messages[:too_long], max_length)
    assert_equal correct_error_message, user.errors.on(:first_name)
    
    # First name is maximum length
    user.first_name = "a" * max_length
    assert user.valid?, "#{user.first_name} should be just short enough to pass"
    
  end

# Make sure Last name cannot be too short.
  test "last name minimum length" do
    user = @valid_user
    min_length = User::LAST_NAME_MIN_LENGTH
    
    # Last name is too short
    user.last_name = "a" * (min_length -1)
    assert !user.valid?, "#{user.last_name} should raise a minimum length error"
    # Format the error message based on minimum length
    correct_error_message = sprintf(@error_messages[:too_short], min_length)
    assert_equal correct_error_message, user.errors(:last_name)
    
    # Last name is minimum length
    user.last_name = "a" * min_length
    assert user.valid?, "#{user.last_name} should be just long enough to pass"
    
  end


# Test the email validator against valid email addresses.
  test "email with valid examples" do
    user = @valid_user
    valid_endings = %w{com org net edu es jp us ne info me}
    valid_emails = valid_endings.collect do |ending|
      "foo.bar_1-9@baz-quux0.example.#{ending}"
    end
    valid_emails.each do |email|
      user.email = email
      assert user.valid?, "#{email} must be a valid email address."
    end
  end
  
# Test the email validator against invalid email addresses.
  test "email with invalid examples" do
    user = @valid_user
    invalid_emails = %w{foobar@example.c @example.com f@com foo@bar..com foobar@example.infod foobar.example.com foo,@example.com foo@ex(ample.com foo@example,com}
    invalid_emails.each do |email|
      user.email = email
      assert !user.valid?, "#{email} test as valid but should not be"
      assert_equal "must be a valid email address.", user.errors(:email)
    end
  end  
  
end
