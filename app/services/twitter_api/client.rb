# frozen_string_literal: true

module TwitterApi
  class Client
    def initialize
      @client = Twitter::REST::Client.new(consumer_key: ENV['TWITTER_API_KEY'],
                                          consumer_secret: ENV['TWITTER_API_SERCRET'],
                                          access_token: ENV['TWITTER_Access_TOKEN'],
                                          access_token_secret: ENV['TWITTER_TOKEN_SERCRET'])
    end

    def create_direct_message(user_id, message)
      target_user = @client&.user(user_id)
      @client.create_direct_message(target_user, message, {})
    end

    def user_search(keyword, count = 20, page = 1, **option)
      if option[:filter_messaged] == '1'
        already_sent_users_id = fetch_already_sent_users_id
        @client.user_search(keyword.to_s, count: count, page: page).map do |user_ob|
          user_ob.attrs[:already_sent_message] = already_sent_users_id.include?(user_ob.id.to_i)
          user_ob.attrs
        end
      else
        @client.user_search(keyword.to_s, count: count, page: page).map(&:attrs)
      end
    rescue Twitter::Error::BadRequest => e
      []
    end

    def fetch_already_sent_users_id
      @client.direct_messages_sent(count: 50).map do |message|
        message.recipient.id.to_i
      end
    end

    def full_text_match(text)
      %("#{text}")
    end
  end
end
