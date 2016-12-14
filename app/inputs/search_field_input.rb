class SearchFieldInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    template.content_tag(:div, class: 'form-inline') do
      template.content_tag(:div, class: 'input-group search-group') do
        # template.concat @builder.text_field(attribute_name, merge_wrapper_options(input_html_options,wrapper_options))
        template.concat @builder.text_field(attribute_name, input_html_options)
        # template.concat span_remove
        template.concat span_table
      end
    end
  end

  def input_html_options
    super.merge({class: 'form-control', readonly: false, size: 7})
  end

  # def span_remove
  #   template.content_tag(:span, class: 'input-group-addon') do
  #     template.concat icon_remove
  #   end
  # end

  def span_table
    template.content_tag(:span, class: 'input-group-addon search-field') do
      template.concat icon_table
    end
  end

  # def icon_remove
  #   "<i class='glyphicon glyphicon-remove'></i>".html_safe
  # end

  def icon_table
    "<i class='glyphicon glyphicon-search'></i>".html_safe
  end

end