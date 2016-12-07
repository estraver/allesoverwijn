class Post::Widget < Cell::Concept
  class Archive::Cell < Cell::Concept
    class Link < self
      include Cell::ListCell

      self.classes = %w(category-links)

      def show
        render :link
      end

      private

      # TODO: Change to route
      def url(link)
        '#'
      end

      def month
        I18n.l(Date.parse(model[0]), format: '%B')
        # _("#{model.key}")
      end

    end

  end
end
