require 'radio_buttons_tree_input'

class CheckBoxesTreeInput < RadioButtonsTreeInput

  def input_button_tag(name, value, options)
    template.check_box_tag(name, value, (@options[:checked] || []).include?(value))
    # template.check_box_tag(name, value, options)
  end

  def name
    "#{object_name}[#{attribute_name}][]"
  end

  def class_style
    'checkbox'
  end


end