# frozen_string_literal: true

class TaskSerializer
  include FastJsonapi::ObjectSerializer
  set_type :task

  belongs_to :author, record_type: :user, serializer: :User
  has_many :cards
  has_many :comments, record_type: :task_comment, serializer: :TaskComment
  has_many :attachments, record_type: :task_attachment, serializer: :TaskAttachment

  attributes :created_at, :updated_at, :title, :details, :formatted_details, :comments_count, :attachments_count, :metadata

  attribute :unseen_comments_count do |task, params|
    task.comments.unseen_by(params[:current_user].id).count if params[:current_user].present?
  end
end
