# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter]

  def self.find_or_create_from_auth(auth)
    user = User.find_by(uid: auth[:uid], provider: auth[:provider])

    user ||= User.create!(
      uid: auth[:uid],
      provider: auth[:provider],
      email: auth[:info][:email],
      password: Devise.friendly_token[0, 20]
    )

    user
  end
end
