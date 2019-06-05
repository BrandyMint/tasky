# frozen_string_literal: true

module LaneStages
  extend ActiveSupport::Concern

  DEFAULT_STAGE = :done
  STAGES = %i[todo doing done].freeze

  included do
    enum stage: STAGES

    before_create do
      self.stage ||= DEAFULT_STAGE
    end
  end
end
