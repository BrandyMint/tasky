# frozen_string_literal: true

class BoardMembersController < ApplicationController
  helper_method :board

  def new
    render locals: { form: BoardInviteForm.new }
  end

  def create
    form = BoardInviteForm.new params.require(:board_invite_form).permit(:email)
    if form.valid?
      board_invite = make_invite form.email
      flash.notice = "Пользователь #{board_invite.email} приглашён!"
      redirect_to board_path(board)
    else
      render :new, locals: { form: form }
    end
  end

  def index
    render locals: { members: board.members, board_invites: board.invites }
  end

  private

  def make_invite(email)
    BoardInviter
      .new(board: board, inviter: current_user, email: email)
      .perform!
  end

  def board
    current_user.boards.find params[:board_id]
  end
end
