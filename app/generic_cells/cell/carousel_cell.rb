module Cell
  module CarouselCell

    def slide(slide)
      if slide.has_view?
        render slide.view
      else
        classes = ['item']
        classes << 'active' if slide.first?
        content_tag(:div, class: classes) do
          image(slide) + content_tag(:div, class: 'carousel-caption') do
            content_tag(:h1, slide.humanize) + note(slide)
          end
        end
      end
    end

    def container(carousel, &block)
      content_tag(:div, class: [:carousel, :slide], id: carousel.name.to_s, data: {ride: 'carousel'}) do
        index(carousel) +
            content_tag(:div, class: 'carousel-inner', role: 'listbox', &block) +
            carousel.controls.map { |control| control(control) }.join.html_safe
      end
    end

    private

    def image(slide)
      if slide.url.nil?
        image_tag "/assets/#{slide.image}"
      else
        link_to(slide.url) do
          image_tag "/assets/#{slide.image}"
        end
      end
    end

    def note(slide)
      begin
        content_tag(:p, eval(slide.note))
      rescue
        content_tag(:p, slide.note)
      end
    end

    def control(control)
      content_tag(:a, class: [control.position, 'carousel-control'], data: {slide: control.slide}, href: "##{control.carousel.name}", role: 'button') do
        content_tag(:span, '', class: ['glyphicon', "glyphicon-#{control.icon}"], aria: {:hidden => true}) + content_tag(:span, control.humanize, class: 'sr-only')
      end

    end

    def index(carousel)
      content_tag(:ol, class: 'carousel-indicators') do
        (0..carousel.slides.size - 1).map do |slide_index|
          content_tag(:li, '', data: {target: "##{carousel.name}", 'slide-to': slide_index}, class: slide_index.eql?(0) ? 'active' : nil)
        end.join.html_safe
      end
    end

  end
end
