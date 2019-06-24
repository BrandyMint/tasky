import React from 'react'
import { CardTitle, Footer } from './styles/Base'

import Tag from 'react-trello/src/components/Tag'

const Card = ({ card, tagStyle }) => {
  const { id, title, description, tags, commentsCount, memberships } = card;
  const showDescription = (description || '').length > 0
  const showTags = (tags || []).length > 0
  const showFooter = showDescription || showTags || commentsCount > 0 || (memberships || []).length > 0
  return (
    <span>
      <CardTitle>{title}</CardTitle>
      {showFooter &&
        <Footer className="mt-1">
          <ul className="list-inline mb-0 mr-2">
            {showDescription && <li className="list-inline-item"><i className="ion ion-md-list" /></li>}
            {commentsCount > 0 && <li className="list-inline-item"><i className="ion ion-md-chatboxes" /><small className="ml-1">{commentsCount}</small></li>}
            {(tags || []).map(tag => <li className="list-inline-item" key={tag.title}><Tag {...tag} tagStyle={tag.tagStyle || tagStyle} /></li>)}
            {(memberships || []).map(membership =>
            <li className="list-inline-item" key={membership.id}>
              <img src={membership.avatarUrl} style={{borderRadius:'50%', marginRight: '2px'}} width={24} height={24} title={membership.publicName} alt={membership.publicName} />
            </li>
            )}
          </ul>
        </Footer>
      }
    </span>
  )
}

export default Card
