module ApplicationHelper
  def default_stylesheets
    sheets = ['common', 'coderay', 'slide']
    sheets << {:cache => 'main'}

    stylesheet_link_tag *sheets
  end

  def default_javascripts
    libs = [:defaults]
    libs << {:cache => 'main'}

    javascript_include_tag *libs
  end
  
  # Returns a string with an object identifier
  # 
  # * _prefix_:: The prefix to append in the ID
  # * _form_builder_:: The form builder object
  def dynamic_object_id(prefix, form_builder)
    "#{prefix}_#{form_builder.object_name.to_s.gsub(/[_\]\[]+/, '_')}"
  end
  
  # Return the error messages from a model in HTML format
  # 
  # * _model_:: The model to inspect for errors
  def show_error_messages(model)
    unless model.errors.empty?
      render :partial => 'shared/error_messages', :locals => { :model => model }
    end
  end
  
  def generate_html(form_builder, method, user_options = {})
    options = {
      :object => form_builder.object.class.reflect_on_association(method).klass.new,
      :partial => method.to_s.singularize,
      :form_builder_local => :f,
      :locals => {},
      :child_index => 'NEW_RECORD',
      :is_dynamic => true
    }.merge(user_options)
    form_options = { :child_index => options[:child_index] }

    form_builder.fields_for(method, options[:object], form_options) do |f|
      render(
        :partial => options[:partial],
        :locals => {
          options[:form_builder_local] => f,
          :is_dynamic => options[:is_dynamic]
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
    out << fields.hidden_field(:_destroy, :class => :destroy,
      :value => fields.object.marked_for_destruction? ? 1 : 0) unless new_record
    out << link_to('X', '#', :title => t(:'label.delete'),
      :'data-target' => ".#{class_for_remove || fields.object.class.name.underscore}",
      :'data-event' => (new_record ? 'removeItem' : 'hideItem'))

    raw out
  end
  
  # Returns the pagination links for the objects collection
  #
  # * _objects_:: The collection objects
  def pagination_links(objects)
    previous_label = "&laquo; #{t :'label.previous'}".html_safe
    next_label = "#{t :'label.next'} &raquo;".html_safe

    result = will_paginate objects, :previous_label => previous_label,
      :next_label => next_label, :inner_window => 1, :outer_window => 1

    result ||= content_tag(:div, content_tag(:span, previous_label,
        :class => 'disabled prev_page') + content_tag(:em, 1) +
        content_tag(:span, next_label, :class => 'disabled next_page'),
      :class => :pagination)

    result
  end
end