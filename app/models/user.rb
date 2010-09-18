class User < ActiveRecord::Base
  
  # min and max length for validations
  FIRST_NAME_MIN_LENGTH = 4
  FIRST_NAME_MAX_LENGTH = 40
  LAST_NAME_MIN_LENGTH = 4
  LAST_NAME_MAX_LENGTH = 40
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 60
  FIRST_NAME_RANGE = FIRST_NAME_MIN_LENGTH..FIRST_NAME_MAX_LENGTH
  LAST_NAME_RANGE = LAST_NAME_MIN_LENGTH..LAST_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH

  # Text box sizes for displaying in the views
  FIRST_NAME_SIZE = 20
  LAST_NAME_SIZE = 20
  PASSWORD_SIZE = 10
  EMAIL_SIZE = 30

  # Validations
  validates_uniqueness_of     :email
  validates_length_of         :first_name, :within => FIRST_NAME_RANGE
  validates_length_of         :last_name, :within => LAST_NAME_RANGE
  validates_length_of         :password, :within => PASSWORD_RANGE
  validates_length_of         :email, :maximum => EMAIL_MAX_LENGTH
  #validates_presence_of       :email, :first_name, :last_name, :password

  validates_format_of       :first_name,
                            :with => /^[A-Z0-9_]*$/i,
                            :message => "must contain only letters," +
                                        "numbers, and underscores"

  validates_format_of       :last_name,
                            :with => /^[A-Z0-9_]*$/i,
                            :message => "must contain only letters," +
                                        "numbers, and underscores"

  validates_format_of       :email,
                            :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                            :message => "must be a valid email address."
  
end
