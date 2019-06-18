import React, {Component} from 'react'
import PropTypes from 'prop-types'
import {CardHeader, CardRightContent, CardTitle, CardWrapper, Detail} from './styles/Base'
import EditableLabel from 'react-trello/src/components/widgets/EditableLabel'
import {AddButton, CancelButton} from './styles/Elements'
import InlineInput from 'react-trello/src/components/widgets/InlineInput'

import ClickOutside from 'react-click-outside'

class NewCard extends Component {
  state = { }

  updateField = (field, value) => {
    this.setState({[field]: value})
  }

  handleAdd = () => {
    this.props.onAdd(this.state)
  }

  render() {
    const {onCancel, t} = this.props

    const onClickOutside = () => {
      if ((this.state.title || '').length > 0) {
        this.handleAdd()
      } else {
        onCancel()
      }
    }

    const onChange = (val) => {
      this.updateField('title', val)
      this.props.onAdd({title: val})
    }

    return (
      <ClickOutside style={{background: '#E3E3E3'}} onClickOutside={onClickOutside}>
        <CardWrapper>
          <CardTitle>
            <InlineInput placeholder={t('placeholder.title')} onChange={onChange} autoFocus autoResize resize='vertical'/>
          </CardTitle>
        </CardWrapper>
        <button className='btn btn-primary btn-sm' onClick={this.handleAdd}>{t('button.Add')}</button>
        <CancelButton onClick={onCancel}><i className='ion ion-md-close icon-lg'/></CancelButton>
      </ClickOutside>
    )
  }
}

NewCard.propTypes = {
  laneId: PropTypes.string.isRequired,
  onCancel: PropTypes.func.isRequired,
  onAdd: PropTypes.func.isRequired,
  t: PropTypes.func.isRequired,
}

export default NewCard
