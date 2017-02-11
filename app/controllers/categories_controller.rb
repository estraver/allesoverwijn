class CategoriesController < ApplicationController
  respond_to :html, :json, :js

  def new
    form Category::Create
    render html: cell(Category::Cell::New, @model, context: { current_user: current_user, operation: @operation, title: _('category.new') } )
  end

  def create
    respond Category::Create do |op, format|
      format.json {
        render_json op, 'category.created'
      }
      format.js { render :new }
    end

  end
end
