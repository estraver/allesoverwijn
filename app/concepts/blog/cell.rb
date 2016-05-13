require 'abstract_post/abstract_post'

class Blog::Cell < Cell::Concept
  include Cell::ContentCell

  def show
    render
  end

  def preview?
    @options[:preview]
  end

  private

  def comments_count
    0
  end

  def views_count
    0
  end

  class List < Cell::Concept
    inherit_views Blog::Cell

    property :published
    property :current_user

    def show
      render :list
    end
  end

  class Show < Cell::Concept
    inherit_views Blog::Cell

    def show
      concept('blog/cell', model, operation: @options[:operation], preview: @options[:preview])
    end
  end

end
