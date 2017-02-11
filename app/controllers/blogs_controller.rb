# require_dependency 'blog/operations'
# require_dependency 'transfer/operations'

class BlogsController < ApplicationController
  respond_to :html, :json, :js

  def index
    # FIXME: Make render_collection method
    collection Blog::Index
    render html: _cell(Blog::Cell::Index, collection: @operation.published, context: { current_user: current_user, widgets: blog_widgets }, layout: Post::Cell::Layout::Index), layout: :default
    # render html: cell(Post::Cell::Index::Empty, nil, context: { current_user: current_user, widgets: blog_widgets, model: Blog }, layout: Post::Cell::Layout::Index), layout: :default if @operation.published.empty?
  end

  def show
    present Blog::Show
    render html: cell(Blog::Cell::Show, @model, context: { current_user: current_user, operation: @operation, preview: @preview, title: _('blog.show') }, layout: Post::Cell::Layout::Show), layout: :default
  end

  def edit
    form Blog::Update
    render html: cell(Blog::Cell::Edit, @model, context: {current_user: current_user, operation: @operation, widgets: blog_edit_widgets, title: _('blog.edit')}, layout: Post::Cell::Layout::Edit), layout: :default
  end

  def close
    respond Blog::Close do |op, format|
      if op.valid?
        format.json {
          return render json: { status: :redirect, location: url_for(op.model) }
        }
        format.html { return redirect_to op.model }
      else
        @title = _('blog.close.confirm.title')
        @message = _('blog.close.confirm.message')

        respond_to do | format |
          format.json { return render json: {status: :confirm, title: @title, message: @message}}
          format.js { return render :confirm }
        end
      end

    end
  end

  def preview
    run Blog::Preview do | op |
      @preview = true
      render html: cell(Blog::Cell::Show, @model, context: { current_user: current_user, operation: @operation, preview: @preview, title: _('blog.show') }, layout: Post::Cell::Layout::Show), layout: :default
    end

  end

  def update
    respond Blog::Update do |op, format|
      format.json {
        render_json op, 'blog.updated'
      }
      format.js { render :edit }
    end

  end

  def upload
    respond Blog::Upload do | op, format |
      format.json { render_json op, 'post.picture.upload' }
      format.html
    end
  end

  def sidebar
    present Blog::Update
    render html: cell("post/cell/sidebar/#{params[:widget].to_s.singularize}".camelize.constantize, @model, context: { current_user: current_user, operation: @operation })
  end

  private

  def blog_widgets
    %w(categories archives)
  end

  def blog_edit_widgets
    %w(picture categories tags publish properties)
  end

end
