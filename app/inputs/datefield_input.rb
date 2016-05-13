class DatefieldInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    format = merged_input_options.delete(:format) || {order: [:year, :month, :day], separator: '-'}

    date_fields = build_date_text_fields(format, object.send(attribute_name), merged_input_options.dup)

    template.content_tag(:div, class: :datefield) do
      "#{date_fields.join(format[:separator])}\n".html_safe +
       "#{@builder.hidden_field(attribute_name, merged_input_options)}\n".html_safe
    end
  end

  private

  def build_date_text_fields(format, value, options)
    placeholder = (options.delete(:placeholder) || '').split(format[:separator])

    value = Date.parse(value) if value.is_a? String

    format[:order].each_with_index.map do | component, idx |
      if placeholder.size > 0
        options[:placeholder] = placeholder[idx]
        options[:maxlength] = placeholder[idx].length
      else
        options[:maxlength] = component.size.eql?(4) ? 4 : 2
      end

      options['data-date-component'] = component
      template.text_field_tag(attribute_name.to_s + '_' + component.to_s, value.nil? ? nil :  value.send(component), options.to_hash)

    end
  end

end