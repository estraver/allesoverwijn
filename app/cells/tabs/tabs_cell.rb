module Tabs
  class TabsCell < Cell::ViewModel
    include Layout::External

    def pills
      render :pills
    end

    def pills_and_stacked
      render :pills_and_stacked
    end

    def classes
      html_options[:class]
    end

    def navs(tabs)
      tabs.panels.collect do | pane |
        content_tag :li, role:'presentation', class: nav_classes(pane) do
          link_to "##{pane.name}", data: {url: url(pane)}, role: 'tab' do
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
      /^#{pane.panel}/ =~ context[:section].to_s
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

    def url(pane)
      return pane.url(context[:url_options], 'edit_') if context[:controller].action_name.eql? 'edit'
      pane.url(context[:url_options])
    end
  end
end