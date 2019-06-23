# frozen_string_literal: true

class AccountSerializer
  include FastJsonapi::ObjectSerializer
  set_type :account

  belongs_to :owner, record_type: :user, serializer: :User

  attributes :name, :api_url, :home_url, :metadata
end
