require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "should successfully save when all fields are valid" do
      @user = User.new(:first_name => "John", :last_name => "Blohn", :email => "test@gmail.com", :password => "testpassword", :password_confirmation => "testpassword")
      @user.save
      expect(@user.errors.full_messages).to be_empty
      expect(User.all).to include(@user)
    end

    it "should fail when password and password_confirmation fields do not match" do
      @user = User.new(:first_name => "John", :last_name => "Blohn",  :email => "test@gmail.com", :password => "testpassword", :password_confirmation => "223s")
      @user.save
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      expect(User.all).not_to include(@user)
    end

    it "should fail when first name field is nil" do
      @user = User.new(:first_name => nil, :last_name => "Blohn",  :email => "test@gmail.com", :password => "testpassword", :password_confirmation => "testpassword")
      @user.save
      expect(@user.errors.full_messages).to include("First name can't be blank")
      expect(User.all).not_to include(@user)
    end

    it "should fail when last name field is nil" do
      @user = User.new(:first_name => "John", :last_name => nil,  :email => "test@gmail.com", :password => "testpassword", :password_confirmation => "testpassword")
      @user.save
      expect(@user.errors.full_messages).to include("Last name can't be blank")
      expect(User.all).not_to include(@user)
    end

    it "should fail when email field is nil" do
      @user = User.new(:first_name => "John", :last_name => "Blohn",  :email => nil, :password => "testpassword", :password_confirmation => "testpassword")
      @user.save
      expect(@user.errors.full_messages).to include("Email can't be blank")
      expect(User.all).not_to include(@user)
    end

    it "should fail when email is not unique" do
      @user1 = User.new(:first_name => "John", :last_name => "Blohn",  :email => "TEST@TEST.com", :password => "testpassword", :password_confirmation => "testpassword")
      @user2 = User.new(:first_name => "Johnn", :last_name => "Blohnn",  :email => "test@test.COM", :password => "testpasswordd", :password_confirmation => "testpasswordd")
      @user1.save
      @user2.save
      expect(@user2.errors.full_messages).to include("Email has already been taken")
      expect(User.all).to include(@user1)
      expect(User.all).not_to include(@user2)
    end

    it "should fail when password less than 6 characters" do
      @user = User.new(:first_name => "John", :last_name => "Blohn",  :email => "TEST@TEST.com", :password => "ad", :password_confirmation => "ad")
      @user.save
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      expect(User.all).not_to include(@user)
    end

    it "should fail when password greater than 20 characters" do
      @user = User.new(:first_name => "John", :last_name => "Blohn",  :email => "TEST@TEST.com", :password => "123456789012345678901", :password_confirmation => "123456789012345678901")
      @user.save
      expect(@user.errors.full_messages).to include("Password is too long (maximum is 20 characters)")
      expect(User.all).not_to include(@user)
    end
  end

  describe ".authenticate_with_credentials" do
    before do
      @user = User.new(:first_name => "John", :last_name => "Blohn",  :email => "TEST@TEST.com", :password => "1234567", :password_confirmation => "1234567")
      @user.save
    end

    it "should succeed when email matches exactly" do
      response = User.authenticate_with_credentials("TEST@TEST.com", "1234567")
      expect(response).to be_a User
    end

    it "should fail when email does not match" do
      response = User.authenticate_with_credentials("TEST1@TEST.com", "1234567")
      expect(response).to be nil
    end

    it "should fail when password does not match" do
      response = User.authenticate_with_credentials("TEST@TEST.com", "12347")
      expect(response).to be nil
    end

    it "should succeed when email inputted has leading spaces" do
      response = User.authenticate_with_credentials("     TEST@TEST.com", "1234567")
      expect(response).to be_a User
    end

    it "should succeed when email inputted has trailing spaces" do
      response = User.authenticate_with_credentials("TEST@TEST.com   ", "1234567")
      expect(response).to be_a User
    end

    it "should succeed when case is different" do
      response = User.authenticate_with_credentials("test@test.COM", "1234567")
      expect(response).to be_a User
    end

  end
end
