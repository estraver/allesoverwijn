module Cell
  module LabelValueCell
    def self.included(base)
      base.inheritable_attr :base_class
    end

    private

    def fields(fields, model, label='')
      fields.map do | field |
        content_tag(:div, class: ["#{self.class.base_class}", 'clearfix']) do
          content_tag(:div, label(field, model, label), class: "#{self.class.base_class}-label") +
            content_tag(:div, value(field, model), class: "#{self.class.base_class}-value")
        end
      end.join('').html_safe

    end

    def label(field, model, label='')
      lbl = "views.#{model.class.name.downcase}"
      lbl << ".#{label}" unless label.empty?
      lbl << ".#{field}"
      _(lbl)
    end

    def value(field, model)
      model.send(field) if model.respond_to?(field)
    end

  end

end