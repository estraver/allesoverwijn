module Cell
  module NavigationCell
    def self.included(base)
      base.inheritable_attr :classes
    end

    def navigate_to(link, &block)
      if block_given?
        content_tag(:li, class: 'nav-item dropdown') do
          url_options = {data: {toggle: 'dropdown', hover: 'dropdown', delay: 1000, 'close-others': true}}.merge link.url_options || {}
          link_to(link.url, url_options) do
            icon = content_tag(:span, '', class: link.icon)
            link_text = content_tag(:span, link.humanize)
            dropdown = content_tag(:i, '', class: [:fa, 'fa-angle-down'])
            icon + link_text + dropdown
          end + content_tag(:ul, class: 'dropdown-menu', &block)
        end
      else
        content_tag(:li, class: 'nav-item') do
          if link.has_icon?
            link_to(link.url, link.url_options) do
              content_tag(:span, link.humanize, class: link.icon)
            end
          else
            link_to link.humanize, link.url, link.url_options
          end

        end
      end
    end

    def classes
      internal_classes = %w(nav navbar-nav)
      if self.class.classes.is_a?(Array)
        self.class.classes.clone << internal_classes
      else
        internal_classes
      end

    end

    def container(&block)
      content_tag(:ul, class: classes, &block)
    end
  end
end
