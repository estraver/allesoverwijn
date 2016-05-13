require_dependency 'blog/operations'

class BlogsController < ApplicationController
  respond_to :html, :json, :js

  def index
    collection Blog::Index
  end

  def show
    present Blog::Show
  end

  def edit
    form Blog::Update
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
    upload_class = params.key?(:id) ? Blog::Update::Upload : Blog::Create::Upload

    respond upload_class do | op, format |
      format.json { render_json op, 'post.picture.upload' }
      format.html
    end
  end

end
