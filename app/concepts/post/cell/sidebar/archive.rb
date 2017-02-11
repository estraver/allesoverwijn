module Post::Cell
  module Sidebar
    class Archive < Trailblazer::Cell
      include Cell::ListCell

      layout :widget_show_layout

      self.classes = %w(archive-links)

      def title
        _('posts.sidebar.archives')
      end

      # def show
      #   archives.map { |archive| list_item archive, url(archive), "#{month(archive)} #{Date.parse(archive[0]).year}" }.join
      # end

      private

      def archives
        ArchiveCollection.new(::Property).()
      end

      # TODO:
      def url(link)
        '#'
      end

      def month(archive)
        I18n.l(Date.parse(archive[0]), format: '%B')
        # _("#{model.key}")
      end
    end
  end
end