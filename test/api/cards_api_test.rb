# frozen_string_literal: true

require 'test_helper'

class CardsAPITest < ActionDispatch::IntegrationTest
  setup do
    login_user
    @current_account = create :account, owner: @current_user
    @board = create :board, account: @current_account
    create :lane, board: @board
  end

  test 'GET /api/v1/cards with :board_id' do
    create :card, board: @board, lane: @board.income_lane!
    get '/api/v1/cards', params: { board_id: @board.id }
    assert response.successful?
    assert_equal 1, JSON.parse(response.body)['data'].count
  end

  test 'GET /api/v1/cards with :lane_id' do
    create :card, board: @board, lane: @board.income_lane!
    get '/api/v1/cards', params: { lane_id: @board.income_lane.id }
    assert response.successful?
    assert_equal 1, JSON.parse(response.body)['data'].count
  end

  test 'POST /api/v1/cards' do
    title = generate :title
    post '/api/v1/cards', params: { board_id: @board.id, title: title }
    assert response.successful?
    assert_equal 1, @current_account.cards.count
    assert_equal title, @current_account.cards.first.title
  end

  test 'PUT /api/v1/cards/:id' do
    card = create :card, lane: @board.income_lane
    title = generate :title
    details = generate :details
    put "/api/v1/cards/#{card.id}", params: { title: title, details: details }
    assert response.successful?
    card = card.reload
    assert_equal title, card.title
    assert_equal details, card.details
  end

  test 'DELETE /api/v1/cards/:id' do
    card = create :card, lane: @board.income_lane
    delete "/api/v1/cards/#{card.id}"
    assert response.successful?

    assert_raises ActiveRecord::RecordNotFound do
      card.reload
    end
  end

  test 'PUT /api/v1/cards/:id/move_across' do
    income_lane = create :lane, :with_cards, board: @board, cards_count: 3
    card = create :card, lane: income_lane
    next_lane = create :lane, board: @board
    assert_equal [0, 1, 2, 3], income_lane.cards.ordered.pluck(:position)
    assert_equal [], next_lane.cards.ordered.pluck(:position)
    put "/api/v1/cards/#{card.id}/move_across", params: { to_lane_id: next_lane.id, index: 0 }
    assert_equal [0, 1, 2], income_lane.cards.ordered.pluck(:position)
    assert_equal [0], next_lane.cards.ordered.pluck(:position)
    assert response.successful?
    assert_not_includes income_lane.reload.cards, card
    assert_includes next_lane.reload.cards, card
  end
end
