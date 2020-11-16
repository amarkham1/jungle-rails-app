class User < ActiveRecord::Base
  has_secure_password
  
  has_many :orders

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { in: 6..20 }
  validates :password_digest, presence: true
  before_validation :lowercase_and_strip

  def self.authenticate_with_credentials(email, password)
    @user = User.find_by_email(email.strip.downcase)
    if @user && @user.authenticate(password)
      return @user
    else
      return nil
    end
  end

  private

  def lowercase_and_strip
    if self.email
      self.email = self.email.strip.downcase
    end
  end
end
