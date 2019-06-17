import axios from 'axios'

import ajaxErrorHandler from './ajaxErrorHandler'

const requestor = axios.create({
  withCredentials: true,
  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/vnd.api+json'
  }
})

const request = (method, url, params = {}) => {
  NProgress.start()
  requestor
  .request({method: method, url: url, params: params})
  .catch(ajaxErrorHandler)
  .finally(NProgress.done)
}

export const apiAddCard = (card, laneId) => {
  request('post', `/lanes/${laneId}/cards/with_task`, { id: card.id, title: card.title })
}

export const apiDeleteCard = (cardId, laneId) => {
  request('delete', `/lanes/${laneId}/cards/${cardId}`)
}

export const apiAddLane = (boardId, title) => {
  request('post', `/boards/${boardId}/lanes`, { title: title })
}

export const apiDeleteLane = (boardId, laneId) => {
  request('delete', `/boards/${boardId}/lanes/${laneId}`)
}

export const apiMoveCardAcrossLanes = (fromLaneId, toLaneId, cardId, addedIndex) => {
  request('put', `/lanes/${fromLaneId}/cards/${cardId}/move_across`, { to_lane_id: toLaneId, index: addedIndex })
}

export const apiMoveLane = (laneId, addedIndex) => {
  request('put', `/lanes/${laneId}/move`, { index: addedIndex })
}

export const apiAddTaskComment = (taskId, commentId, content) => {
  request('post', `/tasks/${taskId}/comments`, { id: commentId, content: content })
}
