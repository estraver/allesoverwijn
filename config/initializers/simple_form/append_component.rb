module SimpleForm
  module Components
    module IconAppend
      # Name of the component method
      def icon_append(wrapper_options = nil)
        @icon_append ||= begin
          tag(:span, class: ['glyphicon', "glyphicon-#{options[:icon_append]}"]) if options[:icon_append].present?
        end
      end

      # Used when the there is no icon
      def has_icon_append?
        icon_append.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::IconAppend)