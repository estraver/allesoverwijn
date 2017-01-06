module Post::Cell
  class Index < Trailblazer::Cell
    class Empty < Trailblazer::Cell
      def show
        content_tag :div, class: 'row center-block' do
          content_tag :div, class: %w(panel panel-info) do
            header = content_tag :div, class: 'panel-heading' do
              _('posts.view.nocontent.title')
            end

            body = content_tag :div, class: 'panel-body' do
              _('posts.view.nocontent.message') % (context[:model].to_s)
            end

            header + body
          end
        end
      end
    end
  end
end