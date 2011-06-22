module ApplicationHelper
  def default_stylesheets
    sheets = ['common', 'coderay']
    sheets << {:cache => 'main'}

    stylesheet_link_tag *sheets
  end

  def default_javascripts
    libs = [:defaults]
    libs << {:cache => 'main'}

    javascript_include_tag *libs
  end
  
  # Return the error messages from a model in HTML format
  def show_error_messages(model)
    unless model.errors.empty?
      render :partial => 'shared/error_messages', :locals => { :model => model }
    end
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