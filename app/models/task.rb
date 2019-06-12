# frozen_string_literal: true

class Task < ApplicationRecord
  include Sortable.new parent_id: :lane_id

  belongs_to :lane
  has_one :board, through: :lane
  belongs_to :author, class_name: 'User'

  def change_position(new_position, to_lane = nil)
    raise 'position must be more or eqeual to zero' if new_position < 0

    if to_lane.nil? || to_lane == lane
      change_position_in_lane new_position
    else
      move_task_across_lanes new_position, to_lane
    end
  end

  private

  def move_task_across_lanes(new_position, to_lane)
    board.with_lock do
      from_lane = lane
      from_position = position
      to_lane.tasks.where('position >= ?', new_position)
             .update_all 'position = position + 1' # rubocop:disable Rails/SkipsModelValidations
      update lane: to_lane, position: new_position
      from_lane.tasks.where('position > ?', from_position)
               .update_all 'position = position - 1' # rubocop:disable Rails/SkipsModelValidations
    end
  end

  # rubocop:disable Rails/SkipsModelValidations
  def change_position_in_lane(new_position) # rubocop:disable Metrics/AbcSize
    lane.with_lock do
      if new_position < position
        lane.tasks.where('position >= ?', new_position).update_all 'position = position + 1'
        update_column :position, new_position
      elsif new_position > position
        lane.tasks.where('position >= ?', position).update_all 'position = position - 1'
        update_column :position, new_position
      end
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
