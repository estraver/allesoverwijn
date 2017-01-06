module Cell
  module LabelValueCell
    def self.included(base)
      base.inheritable_attr :base_class
    end

    private

    def fields(fields, model, label='')
      content_tag(:dl, class: ["#{self.class.base_class}", 'dl-horizontal']) do
        fields.map do | field |
            [ content_tag(:dt, label(field, model, label), class: "#{self.class.base_class}-label"),
              content_tag(:dd, value(field, model), class: "#{self.class.base_class}-value") ].join('')
          end.join('').html_safe
      end
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