# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class IntRangeInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: "input-group") do
      input_html_options[:class] << ['form-control']
      template.concat @builder.text_field("#{attribute_name}_from", input_html_options)
      template.concat range_icon
      template.concat @builder.text_field("#{attribute_name}_to", input_html_options)
    end
  end

  def range_icon
    template.content_tag(:span, class: 'input-group-prepend') do
      template.concat '<span class="input-group-text"><i class="material-icons">more_horiz</i></span>'.html_safe
    end
  end

end
