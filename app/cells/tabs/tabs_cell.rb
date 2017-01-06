module Tabs
  class TabsCell < Cell::ViewModel
    include Layout::External

    def classes
      html_options[:class]
    end

    def navs(tabs)
      tabs.panels.collect do | pane |
        content_tag :li, role:'presentation', class: nav_classes(pane) do
          link_to "##{pane.name}", data: {url: pane.url(context[:url_options])}, role: 'tab' do
            content_tag :span, pane.title
          end
        end
      end.join('').html_safe
    end

    def panes(tabs)
      tabs.panels.collect do | pane |
        content_tag :div, role: 'tabpanel', class: pane_classes(pane), id: "#{pane.name}" do
          cell(context[:section], model).to_s.html_safe if active?(pane)
        end
      end.join('').html_safe
    end

    def active?(pane)
      context[:section].to_s.eql? pane.panel
    end

    def html_options
      context[:html_options] || {}
    end

    def nav_classes(pane)
      'active' if active?(pane)
    end

    def pane_classes(pane)
      klass = %w(tab-pane fade)
      klass += %w(in active) if active?(pane)
      klass
    end
  end
end