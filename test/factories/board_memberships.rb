# frozen_string_literal: true

FactoryBot.define do
  factory :board_membership do
    board
    member
  end
end
