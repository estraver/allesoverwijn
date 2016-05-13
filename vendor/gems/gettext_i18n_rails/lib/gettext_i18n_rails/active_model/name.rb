module ActiveModel
  Name.class_eval do
    def human(options={})

      human_name = @klass.humanize_class_name if @klass.respond_to? :humaize_class_name
      human_name = @klass.model_name.name.underscore.humanize if @klass.respond_to? :model_name

      if count = options[:count]
        n_(human_name, human_name.pluralize, count)
      else
        _(human_name)
      end
    end
  end
end
