module Cell
  module ListCell
    def self.included(base)
      base.inheritable_attr :classes
      base.inheritable_attr :active
      base.inheritable_attr :current_user
    end

    def classes
      internal_classes = %w(nav)
      if self.class.classes.is_a?(Array)
        self.class.classes.clone << internal_classes
      else
        internal_classes
      end

    end

    private

    def list_item(item, model)
      content_tag(:li, class: item.to_s.eql?(self.class.active) && :active) do
        link_to _("views.profile.edit.#{item}"), [:edit, self.class.current_user, model, item]
      end
    end

    def container(&block)
      content_tag(:ul, class: classes, &block)
    end
  end
end
