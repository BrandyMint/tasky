# frozen_string_literal: true

class Account < ApplicationRecord
  include MetadataSupport
  include Archivable

  nilify_blanks

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id, inverse_of: :owned_accounts

  has_many :memberships, dependent: :delete_all, class_name: 'AccountMembership'
  has_many :members,     through: :memberships, class_name: 'User'
  has_many :invites,     dependent: :delete_all
  has_many :boards,      dependent: :delete_all
  has_many :lanes,       through: :boards
  has_many :tasks,       dependent: :delete_all
  has_many :cards,       through: :lanes
  has_many :board_memberships, through: :boards, source: :memberships

  scope :ordered, -> { order :name }
  scope :personal_order, ->(owner_id) { order Arel.sql "CASE WHEN(owner_id='#{owner_id}') THEN 0 ELSE 1 END, name" }
  validates :name, presence: true

  after_create :attach_owner

  def public_name
    # TODO: is_personal
    name
  end

  private

  def attach_owner
    members << owner
  end
end
