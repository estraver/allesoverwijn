require 'test_helper'
require 'post/operations'

class PostCreateTest < MiniTest::Spec
  # Because Post is een abstract concept, we need to use a specific model for testing with Post
  # For testing purposes we create a specific operation with Blog as a model
  class PostTestCreateOp < Post::Create
    include Model

    model Blog, :create

    contract do
      property :post, form: AbstractPost::ContentForm, populator: -> (model:, **) {
        model
      }

      property :post_schedule, virtual: true

    end

    def process(params)
      validate(params[:blog]) do | contract |
        contract.save
      end
    end
  end

  let (:current_user) { users(:admin) }
  let (:blog_article) { '<p>Dit is een blog tekst dat hoort bij de de test van de update en creatie.</p><p>Twee paragrafen zijn noodzakelijke!</p>' }

  it 'Blog is created, but not published' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: current_user.id, article: blog_article}}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.size.must_equal 1
  end


end
