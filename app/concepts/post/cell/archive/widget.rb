module Post::Cell
  module Archive
    class Widget < Trailblazer::Cell
      # layout 'post/cell/sidebar/index'
      # layout Post::Cell::Sidebar::Index

      include Cell::ListCell

      self.classes = %w(archive-links)

      def title
        _('posts.sidebar.archives')
      end

      # def show
      #   archives.map { |archive| list_item archive, url(archive), "#{month(archive)} #{Date.parse(archive[0]).year}" }.join
      # end

      private

      def archives
        ArchiveCollection.new(Property).()
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