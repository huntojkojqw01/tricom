module ApplicationHelper

  def current_url(new_params)
    # i merge curent url with csv format.
    # link to change to <%= link_to "name link", current_url(:format => :csv)%>
    url_for :params => params.merge(new_params)
  end
  def full_title(page_title = '')
    base_title = "TRICOM"
    if page_title.empty?
      base_title
    else
      page_title
    end
  end

end

# Add to config/initializers/form.rb or the end of app/helpers/application_helper.rb
module ActionView
  module Helpers
    class FormBuilder
      def date_select(method, options = {}, html_options = {})
        existing_date = @object.send(method)
        formatted_date = existing_date.to_date.strftime("%F") if existing_date.present?
        @template.content_tag(:div, :class => "input-group") do
          text_field(method, :value => formatted_date, size: 7, :class => "form-control", :"data-date-format" => "YYYY-MM-DD") +
              @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-calendar") ,:class => "input-group-addon")
        end
      end

      def datetime_select(method, options = {}, html_options = {})
        existing_time = @object.send(method)
        formatted_time = existing_time.to_time.strftime("%F %H:%M") if existing_time.present?
        @template.content_tag(:div, :class => "input-group") do
          text_field(method, value: existing_time, :class => "form-control") +
              @template.content_tag(:span, @template.content_tag(:button, @template.content_tag(:span,"", class: "glyphicon glyphicon-calendar", "aria-hidden" => true), :class => "btn btn-default", id: "#{method}", type: "button") ,:class => "input-group-btn")
        end
      end

      def text_field_search(method, options = {}, html_options = {})
        existing_text_field = @object.send(method)
        @template.content_tag(:div, :class => "input-group") do
          text_field(method, :value => existing_text_field, class: "form-control #{html_options[:class_field]}", size: html_options[:size]) +
              @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-search") ,:class => "input-group-addon #{html_options[:class_search]}")
        end
      end

      def text_area_search(method, options = {}, html_options = {})
        existing_area_field = @object.send(method)
        @template.content_tag(:div, :class => "input-group") do
          text_area(method, :value => existing_area_field, class: "form-control custom-control #{html_options[:class_field]}", rows: "3", style: "resize:none", size: html_options[:size]) +
              @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-search") ,:class => "input-group-addon #{html_options[:class_search]}")
        end
      end

    end
  end
end