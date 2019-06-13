# frozen_string_literal: true

class Board < ApplicationRecord
  nilify_blanks

  belongs_to :account

  has_many :memberships, dependent: :delete_all, class_name: 'BoardMembership'
  has_many :members, through: :memberships, class_name: 'User'

  has_many :invites, class_name: 'BoardInvite', dependent: :delete_all

  has_many :lanes, dependent: :delete_all, inverse_of: :board

  validates :title, presence: true, uniqueness: { scope: :account_id }

  scope :ordered, -> { order :id }

  def self.create_with_member!(attrs, member:)
    transaction do
      create!(attrs).tap do |board|
        board.members << member
        LaneStages::STAGES.each_with_index do |stage, index|
          board.lanes.create! title: stage, stage: stage, position: index
        end
      end
    end
  end
end
