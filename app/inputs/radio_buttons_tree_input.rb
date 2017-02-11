class RadioButtonsTreeInput < SimpleForm::Inputs::CollectionInput
  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods
    child_method = options.delete(:children) || :children

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    build_tree collection, label_method, value_method, child_method, merged_input_options
  end

  private

  def build_tree(collection, label_method, value_method, child_method, merged_input_options)
    template.content_tag(:ul, class: 'list-unstyled') do
      collection.map do | item |
        template.content_tag :li do
          template.content_tag :div, class: class_style do
            [ input_button_tag(name, item.send(value_method), merged_input_options),
              template.label_tag(item.send(label_method)),
              build_tree(item.send(child_method), label_method, value_method, child_method, merged_input_options)].join('').html_safe
          end
        end
      end.join('').html_safe
    end if collection.size > 0
  end

  def input_button_tag(name, value, options)
    template.radio_button_tag(name, value, options)
  end

  def name
    namespace = @options[:association].nil? ? '' : "[#{@options[:association]}_attributes]"
    "#{object_name}#{namespace}[#{attribute_name}]"
  end

  def class_style
    'radio'
  end
end