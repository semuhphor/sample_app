require 'spec_helper'

describe User do

  before(:each) do
  	@attr = { 
  	  :name => 'example user', 
  	  :email => 'example@gmail.com',
  	  :password => "foobar",
  	  :password_confirmation => "foobar" }
  end
  
  
  it 'should create a new instance given a valid attribute' do 
  	User.create!(@attr)
  end

  it 'should require a name' do
  	no_name_user = User.new(@attr.merge(:name => nil))
  	no_name_user.should_not be_valid
  end
  
  it 'should require an email address' do
  	no_email_addr = User.new(@attr.merge(:email => nil))
  	no_email_addr.should_not be_valid
  end
  
  it 'should reject names that are too long' do
  	long_name = 'a' * 51
  	long_name_user = User.new(@attr.merge(:name => long_name))
  	long_name_user.should_not be_valid
  end
  
  it 'should accept valid email addresses' do
  	addresses = %w[user@foo.com THE_USER@foo.bar.org f.last@foo.jp]
  	addresses.each do |a|
  		valid_email_user = User.new(@attr.merge(:email => a))
  		valid_email_user.should be_valid
  	end
  end
  
  it 'should not accept invalid email addresses' do
  	addresses = %w[user@foo,com THE_USER_at_foo.bar.org f.last@foo.]
  	addresses.each do |a|
  		invalid_email_user = User.new(@attr.merge(:email => a))
  		invalid_email_user.should_not be_valid
  	end
  end
  
  it 'should reject duplicate email addresses' do
  	User.create!(@attr);
  	user_with_dup_email = User.new(@attr)
  	user_with_dup_email.should_not be_valid
  end
  
  it 'should reject duplicate email address that are only different by case' do
   	upcase_email = @attr[:email].upcase
 	User.create!(@attr.merge(:email => upcase_email))
  	user_with_duplicate_email_address = User.new(@attr)
  	user_with_duplicate_email_address.should_not be_valid
  end
  
  describe "passwords" do
  
    before(:each) do
      @user = User.new(@attr)
    end
  
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
        
  end
  
  describe "password validates" do
  
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => ""))
        .should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "badConfirmation"))
        .should_not be_valid
    end
    
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

