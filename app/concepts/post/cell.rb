require_dependency 'uber/delegates'
require_dependency 'attachment/post_attachment'

class Post::Cell < Cell::Concept
  def show
    render
  end

  class Author < Cell::Concept
    inherit_views Post::Cell
    include Cell::ContentCell

    def show
      render :author
    end

  end

  class Preview < Cell::Concept
    inherit_views Post::Cell

    def show
      render :preview
    end

    private

    def click_trap
      tag :div, style: 'position: absolute; width: 100%; height: 100%; z-index: 1000; background: white none repeat scroll 0% 0%; left: 0; top: 0; cursor: default; opacity: 0.01;'
    end

    def preview_text(text)
      content_tag :div, class: 'preview-watermark' do
        text
      end
    end
  end

  class Picture < Cell::Concept
    extend Uber::Delegates
    delegates :model, :post
    delegates :post, :picture_meta_data

    include Cell::ImageCell.attachments :picture, %w(original sidebar header)

  end
end
