# frozen_string_literal: true

class Card < ApplicationRecord
  include Sortable.new parent_id: :lane_id
  include Archivable

  belongs_to :board
  belongs_to :lane
  belongs_to :task

  has_one :account, through: :board
  has_one :author, through: :task

  has_many :comments, through: :task
  has_many :memberships, class_name: 'CardMembership', dependent: :delete_all
  has_many :account_memberships, through: :memberships
  has_many :members, through: :account_memberships

  before_validation do
    self.board_id ||= lane.try(:board_id)
  end

  delegate :title, :details, :formatted_details, :comments_count, to: :task
end
