class MemberJoinedMessageComposer
    attr_reader :update
    attr_reader :joined_user

    def initialize(update)
      @update = update
    end

    def call
      if joined_via_primary_link?
        return I18n.t("user_joined.via_invite_link.primary",
                      joined_user_name: user_full_name(joined_user),
                      joined_user_id: joined_user.id)
      elsif joined_via_additional_link?
        return I18n.t("user_joined.via_invite_link.additional",
                      joined_user_name: user_full_name(joined_user),
                      joined_user_id: joined_user.id,
                      invite_link_name: invite_link.name,
                      invite_link_creator_name: user_full_name(invite_link.creator),
                      invite_link_creator_id: invite_link.creator.id)
      else
        return I18n.t("user_joined.by_someone",
                      initiator_name: user_full_name(initiator),
                      initiator_id: initiator.id,
                      added_user_name: user_full_name(joined_user),
                      added_user_id: joined_user.id)
      end
    end

    private

    def joined_via_primary_link?
      joined_via_link? && invite_link.is_primary
    end

    def joined_via_additional_link?
      joined_via_link? && !invite_link.is_primary
    end

    def joined_via_link?
      !update.invite_link.nil?
    end

    def invite_link
      update.invite_link
    end

    def joined_user
      update.new_chat_member.user
    end

    def initiator
      update.from
    end

    def user_full_name(user)
      # unnecessary space left when last name is missing when using interpolation to concatenate these strings
      [user.first_name, user.last_name].compact.join(' ')
    end
end