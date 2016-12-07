module Post::Cell
  class Preview < Trailblazer::Cell
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
end