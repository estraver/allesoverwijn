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
    extend Paperdragon::Model::Reader
    processable_reader :picture
    property :picture_meta_data

    def thumb
      image_tag picture[:thumb].url if picture.exists?
    end

    def original
      image_tag picture[:original].url if picture.exists?
    end

    def post_edit_picture
      img = picture.exists? ? picture[:post_edit_picture].url : image_url('/assets/empty-post-picture.png')
      image_tag img, class: %w(profile-img img-responsive centerblock)
    end

  end
end
