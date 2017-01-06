require 'test_helper'
require 'post/operations'
require 'abstract_post/property_type'
require 'abstract_post/properties'

class PostUpdateTest < MiniTest::Spec
  class PostTestCreateOp < Post::Create
    include Model
    include AbstractPost::Properties

    model Blog, :create

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post_attributes
  end

  class PostTestUpdateOp < PostTestCreateOp
    action :update
  end

  let (:current_user) { users(:admin) }
  let (:blog_article) { '<p>This is the welcome blog all about wine.</p> <p>All About Wine is the community where you can find and write all about wine!</p>' }
  let (:blog) { blogs(:welcome_blog) }

  it 'Blog title is updated, no translation' do
    op = PostTestUpdateOp.present(id: blog.id, current_user: current_user.id)
    op.contract.prepopulate!(params: {id: blog.id, current_user: current_user.id})

    res, op = PostTestUpdateOp.run(id: blog.id, blog: {post_attributes: {title: 'Blog Test #2', locale: 'nl', author: {id: op.contract.post.author.id }, article: op.contract.post.article, current_user: current_user.id}}, current_user: current_user.id)

    res.must_equal true
    op.model.persisted?.must_equal true
    op.model.post.post_contents.size.must_equal 1
    op.model.post.post_contents.first.title.must_equal 'Blog Test #2'
  end

  it 'Blog is updated with a new translation' do
    op = PostTestUpdateOp.present(id: blog.id, current_user: current_user.id)
    op.contract.prepopulate!(params: {id: blog.id, current_user: current_user.id})

    res, op = PostTestUpdateOp.run(id: blog.id, blog: {post_attributes: {title: 'Welcome', locale: 'en', author: {id: current_user.id }, article: blog_article}}, current_user: current_user.id)

    res.must_equal true
    op.model.persisted?.must_equal true
    op.model.post.post_contents.size.must_equal 2
  end


end