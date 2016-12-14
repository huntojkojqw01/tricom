class SearchFieldsInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    template.content_tag(:div, class: 'form-inline') do
      template.content_tag(:div, class: 'input-group search-group') do
        # template.concat @builder.text_field(attribute_name, merge_wrapper_options(input_html_options,wrapper_options))
        template.concat @builder.text_field(attribute_name, input_html_options)
        template.concat span_search
        # template.concat span_add
        template.concat span_plus_sign
      end
    end
  end

  def input_html_options
    super.merge({class: 'form-control', readonly: false, size: 7})
  end

  def span_plus_sign
    template.content_tag(:span, class: 'input-group-addon search-plus') do
      template.concat icon_plus_sign
    end
  end

  def span_add
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_add
    end
  end

  def span_search
    template.content_tag(:span, class: 'input-group-addon search-field') do
      template.concat icon_search
    end
  end

  def icon_plus_sign
    "<i class='glyphicon glyphicon-plus-sign'></i>".html_safe
  end

  def icon_add
    "<i class='glyphicon glyphicon-plus'></i>".html_safe
  end

  def icon_search
    "<i class='glyphicon glyphicon-search'></i>".html_safe
  end

end