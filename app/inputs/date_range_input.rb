# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class DateRangeInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: "input-group input-group-datepicker") do
      input_html_options[:class] << ['form-control', 'datepicker']
      template.concat @builder.text_field("#{attribute_name}_from", input_html_options)
      template.concat calender_icon
      template.concat range_icon
      template.concat @builder.text_field("#{attribute_name}_to", input_html_options)
      template.concat calender_icon
    end
  end

  def calender_icon
    template.content_tag(:div, class: 'input-group-prepend for-datepicker') do
      template.concat '<span class="input-group-text"><i class="material-icons">event</i></span>'.html_safe
    end
  end

  def range_icon
    template.content_tag(:span, class: 'input-group-prepend addon') do
      template.concat '<span class="input-group-text"><i class="material-icons">more_horiz</i></span>'.html_safe
    end
  end

end
