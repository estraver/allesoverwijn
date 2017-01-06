module Cell
  module PagerCell
    def self.included(base)
      base.inheritable_attr :classes
    end

    def pager(collection)
      content_tag :nav, 'aria-label': '' do
        content_tag :ul, class: 'pager' do
          previous_link(collection) + next_link(collection)
        end
      end

    end

    private

    def previous_link(collection)
      classes = %w(previous)
      classes.push('disabled') if collection.page.first?
      content_tag :li, class: classes do
        link_to collection.page.previous.url do
          content_tag :span, raw("&larr; #{_('pager.previous')}"), 'aria-hidden': true
        end
      end
    end

    def next_link(collection)
      classes = %w(next)
      classes.push('disabled') if collection.page.last?
      content_tag :li, class: classes do
        link_to collection.page.next.url do
          content_tag :span, raw("#{_('pager.previous')} &rarr;"), 'aria-hidden': true
        end
      end
    end
  end
end