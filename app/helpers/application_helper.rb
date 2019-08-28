# frozen_string_literal: true

module ApplicationHelper
  def bugsnag_options
    options = { appVersion: Bugsnag.configuration.app_version, releaseStage: Rails.env }
    options.to_json
  end

  def bugsnag_user
    if logged_in?
      current_user.as_json(only: %i[id name email]).to_json
    else
      {}
    end
  end

  def app_title
    'Tasky'
  end

  def available_to_delete_membership?(membership)
    !membership.owner?
  end

  def delete_membership_url(membership)
    if membership.is_a? BoardMembership
      board_membership_url membership, subdomain: current_account.subdomain
    elsif membership.is_a? AccountMembership
      account_membership_url membership, subdomain: '', account_id: membership.account_id
    else
      raise 'wtf'
    end
  end

  def sort_memberships(membership)
    membership.sort_by(&:role_enum).reverse
  end

  def pretty_json(data)
    JSON.pretty_generate data
  end

  def available_locales_collection
    I18n.available_locales
  end

  def user_name_with_avatar(user)
    buffer = []

    buffer << gravatar_tag(user, size: 16, html: { style: 'border-radius: 50%' })
    buffer << content_tag(:span, user.public_name, class: 'ml-1 mt-1')

    buffer.join.html_safe
  end

  def humanized_time(time)
    content_tag :span, title: time.to_s do
      l Time.zone.at(time), format: :short
    end
  end

  def title_with_counter(title, count, hide_zero: true, css_class: nil)
    buffer = ''
    buffer += title

    buffer += ' '
    text = hide_zero && count.to_i.zero? ? '' : count.to_s
    # if type == :badge
    # css_class = 'badge-info' if css_class.nil?
    # buffer += content_tag(:span,
    # text,
    # class: ['badge', css_class].compact.join(' '),
    # data: { title_counter: true, count: count.to_i })
    # else
    buffer += content_tag(:span, "(#{text})", class: css_class, data: { title_counter: true, count: count.to_i }) if count > 0

    buffer.html_safe
  end
end
