require_dependency 'blog/operations'
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
    close_class = params.key?(:id) ? Blog::Update::Close : Blog::Create::Close

    respond close_class do |op, format|
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
    preview_class = params.key?(:id) ? Blog::Update::Preview : Blog::Create::Preview

    run preview_class do | op |
      @preview = true
      render :show
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
    respond Post::Upload do | op, format |
      format.json { render_json op, 'post.picture.upload' }
      format.html
    end
  end

  # Parse picture_meta_data
  # def process_params!(params)
  #   super(params)
  #   if params.has_key?(:blog) and params[:blog].has_key?(:post_attributes)
  #     picture_meta_data =  params[:blog][:post_attributes].delete(:picture_meta_data)
  #     params[:blog][:post_attributes].merge!(picture_meta_data: JSON.parse(picture_meta_data, {:symbolize_names => true}))
  #   end
  #
  # end

  private

  def blog_widgets
    # [ :categories, :archives ]
    %w(categories archives)
  end

  def blog_edit_widgets
    # ['picture', ':categories', :'tags', ':publish', ':properties' ]
    %w(picture categories tags publish properties)
  end

end
