class SearchHistoryInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    template.content_tag(:div, class: 'form-inline') do
      template.content_tag(:div, class: 'input-group search-group') do
        template.concat @builder.text_field(attribute_name, input_html_options)

        template.concat span_search
        template.concat span_plus_sign
        template.concat span_search_history
      end
    end
  end

  def input_html_options
    super.merge({class: 'form-control', readonly: false, size: 7})
  end

  def span_plus_sign
    template.content_tag(:span, class: 'input-group-addon search-plus set-border') do
      template.concat icon_plus_sign
    end
  end

  def span_search_history
    template.content_tag(:span, class: 'input-group-addon search-history set-border') do
      template.concat icon_search_history
    end
  end

  def span_search
    template.content_tag(:span, class: 'input-group-addon search-field set-border') do
      template.concat icon_search
    end
  end

  def icon_plus_sign
    "<i class='glyphicon glyphicon-plus-sign'></i>".html_safe
  end

  def icon_search_history
    "<i class='glyphicon glyphicon-time'></i>".html_safe
  end

  def icon_search
    "<i class='glyphicon glyphicon-search'></i>".html_safe
  end

end