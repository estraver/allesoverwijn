class TagsInput < SimpleForm::Inputs::CollectionInput
  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods

    input_html_options.merge!(multiple: true)
    input_html_options.merge!(data: {role: 'tagsinput'})
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.select_tag attribute_name, template.options_from_collection_for_select(collection, value_method, value_method), merged_input_options
  end
end