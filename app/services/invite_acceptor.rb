# frozen_string_literal: true

class InviteAcceptor
  def initialize(invite)
    @invite = invite
  end

  # rubocop:disable Metrics/AbcSize
  def accept!
    invite.with_lock do
      invite.account.members << user
      invite.board.members << user if invite.board.present?
      if invite.task.present?
        invite.task.cards.find_each do |card|
          card.members << user
        end
      end
      invite.delete
    end
    user
  end
  # rubocop:enable Metrics/AbcSize

  private

  attr_reader :invite

  def user
    @user ||= User.create!(email: invite.email, name: invite.email.split('@').first)
  end
end
