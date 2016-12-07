module Cell
  module ListCell
    def self.included(base)
      base.inheritable_attr :classes
    end

    def classes
      internal_classes = []
      if self.class.classes.is_a?(Array)
        self.class.classes.clone << internal_classes
      else
        internal_classes
      end
    end

    private

    def list_item(item, url, title, active = nil)
      klass = [item.class.is_a?(String) ? item : item.class.to_s.downcase]
      klass << :active if item.to_s.eql?(active)
      content_tag(:li, class: klass) do
        link_to title, url, remote: true
      end
    end

    def container(&block)
      content_tag(:nav, class: classes) do
        content_tag(:ul, class: :nav, &block)
      end
    end
  end
end
