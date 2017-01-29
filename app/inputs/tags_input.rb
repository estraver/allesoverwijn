class TagsInput < SimpleForm::Inputs::CollectionInput
  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods

    input_html_options.merge!(multiple: true)
    input_html_options.merge!(data: {role: 'tagsinput'})
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    # template.select_tag "#{@builder.object_name}[#{attribute_name}][][#{value_method}]", template.options_from_collection_for_select(collection, value_method, value_method), merged_input_options

    name = "#{@builder.object_name}[#{attribute_name}_attributes][][#{value_method}]"
    template.content_tag :select, { name: name, id: sanitize_to_id(name) }.update(merged_input_options.stringify_keys)  do
      template.options_from_collection_for_select(collection, value_method, value_method)
    end

  end

  private

  def sanitize_to_id(name)
    name.to_s.delete(']').tr('^-a-zA-Z0-9:.', "_")
  end

end