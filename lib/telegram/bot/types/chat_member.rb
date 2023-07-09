# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMember < Base
        attribute :user, User
        attribute :status, Types::String
      end
    end
  end
end