# frozen_string_literal: true

# Mark task as seen by user

class TaskSeen
  def initialize(task, user)
    @task = task
    @user = user
  end

  def mark_as_seen!(time)
    update_task_user time
    notify
  end

  private

  attr_reader :task, :user

  def update_task_user(time)
    if TaskUser.connection.raw_connection.server_version > 90899
      update_task_user_10 time
    else
      update_task_user_9 time
    end
  end

  def update_task_user_9(time)
  end

  def update_task_user_10(time)
    execute_sql(<<-SQL, task.id, user.id, time, time)
    insert into task_users (task_id, user_id, seen_at)
                values (?, ?, ?)
                on conflict (task_id, user_id)
                do update set (seen_at) = RAW(?)
    SQL
  end

  def execute_sql(*sql_array)
    TaskUser.connection.execute(TaskUser.send(:sanitize_sql_array, sql_array))
  end

  def notify
    task.cards.includes(:board).find_each do |card|
      BoardChannel.update_with_card card.board, card
    end
  end
end
