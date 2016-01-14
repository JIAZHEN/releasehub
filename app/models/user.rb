class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :github_login, type: String
  field :name, type: String
  field :slack_username, type: String
  field :remember_token, type: String
  field :avatar_url, type: String

  index({ github_login: 1 }, { unique: true })
  index({ name: 1 })
  index({ remember_token: 1 }, { unique: true })

  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def set_default_slack_username
    if name
      guessed_name = "#{name.first}#{name.split(' ').last}".downcase
      update_attribute(:slack_username, guessed_name)
    end
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
