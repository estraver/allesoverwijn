module SubmitOnSimpleForms
  def submit_button(field, options = {})
    spinner = options.delete(:spinner) || false
    classes = %w(form-action)
    classes |= (options.delete(:classes) || []).split(' ')

    if field.is_a?(Hash)
      field[:data] ||= {}
      field[:data][:disable_with] ||= 'Processing...'
    else
      options[:data] ||= {}
      options[:data][:disable_with] ||= field
    end
    #FIXED: get column classes from options wrapper
    @template.content_tag(:div, class: classes) do
      tag = @template.submit_tag(field, options)
      tag += @template.content_tag(:i, '', class: %w(fa fa-spinner fa-pulse invisible)) if spinner
      tag
    end
  end
end
SimpleForm::FormBuilder.prepend(SubmitOnSimpleForms)