module ApplicationHelper
  def title
    [t('app.name'), @title].compact.join(' | ')
  end

  # Returns a string with an object identifier
  #
  # * _prefix_:: The prefix to append in the ID
  # * _form_builder_:: The form builder object
  def dynamic_object_id(prefix, form_builder)
    "#{prefix}_#{form_builder.object_name.to_s.gsub(/[_\]\[]+/, '_')}"
  end

  def generate_html(form_builder, method, user_options = {})
    options = {
      object: form_builder.object.class.reflect_on_association(method).klass.new,
      partial: method.to_s.singularize,
      form_builder_local: :f,
      locals: {},
      child_index: 'NEW_RECORD',
      is_dynamic: true
    }.merge(user_options)
    form_options = { child_index: options[:child_index] }

    form_builder.simple_fields_for(method, options[:object], form_options) do |f|
      render(
        partial: options[:partial],
        locals: {
          options[:form_builder_local] => f,
          is_dynamic: options[:is_dynamic]
        }.merge(options[:locals])
      )
    end
  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end

  # Returns a link to remove a nested item
  #
  # * _fields_:: The fields_for builder
  # * _class_for_remove_:: Optional HTML class name to use for remove
  def link_to_remove_nested_item(fields = nil, class_for_remove = nil)
    new_record = fields.nil? || fields.object.new_record?
    out = String.new
    out << fields.hidden_field(:_destroy, class: :destroy,
      value: fields.object.marked_for_destruction? ? 1 : 0) unless new_record
    out << link_to(
      '&times;'.html_safe, '#', title: t('label.delete'),
      class: 'btn btn-xs btn-danger',
      data: {
        target: ".#{class_for_remove || fields.object.class.name.underscore}",
        event: (new_record ? 'removeItem' : 'hideItem')
      }
    )

    raw out
  end

  # Returns the pagination links for the objects collection
  #
  # * _objects_:: The collection objects
  def pagination_links(objects, params = nil)
    result = will_paginate objects,
      inner_window: 1, outer_window: 1, params: params,
      renderer: BootstrapPaginationHelper::LinkRenderer,
      class: 'pagination pull-right'
    page_entries = content_tag(
      :blockquote,
      content_tag(:small, page_entries_info(objects), class: 'page-entries'),
      class: 'visible-sm visible-xs pull-right'
    )

    unless result
      previous_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.previous_label').html_safe),
        class: 'previous_page disabled'
      )
      next_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.next_label').html_safe),
        class: 'next disabled'
      )

      result = content_tag(:ul, previous_tag + next_tag, class: 'pagination pull-right')
    end

    content_tag(:div, page_entries, class: 'clearfix') + content_tag(:div, result, class: 'clearfix')
  end

  def textilize(text)
    textilized = RedCloth.new(text, [:hard_breaks])
    textilized.hard_breaks = true if textilized.respond_to?(:'hard_breaks=')

    raw textilized.to_html
  end
end
