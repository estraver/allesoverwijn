module SimpleForm
  module Components
    module IconPrepend
      # Name of the component method
      def icon_prepend(wrapper_options = nil)
        @icon_prepend ||= begin
          tag(:span, class: ['glyphicon', "glyphicon-#{options[:icon_prepend]}"]) if options[:icon_prepend].present?
        end
      end

      # Used when the there is no icon
      def has_icon_prepend?
        icon_prepend.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::IconPrepend)