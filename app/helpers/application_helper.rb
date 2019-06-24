# frozen_string_literal: true

module ApplicationHelper
  def app_title
    'Tasky'
  end

  def available_locales_collection
    I18n.available_locales
  end

  def user_name_with_avatar(user)
    buffer = []

    buffer << gravatar_tag(user, size: 16, default: :monsterid, html: { style: 'border-radius: 50%' })
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
