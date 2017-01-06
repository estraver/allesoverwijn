require 'test_helper'

require 'post/operations'
require 'abstract_post/property_type'
require 'abstract_post/properties'
require 'post_util/close'

class PostCloseTest < MiniTest::Spec
  class PostTestCreateOp < Post::Create
    include Model
    include AbstractPost::Properties
    include PostUtil::Close

    model Blog, :create

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post_attributes

  end

  class PostTestUpdateOp < PostTestCreateOp
    action :update

    class Close < Close
      action :update
    end
  end

  let (:current_user) { users(:admin) }
  let (:blog) { blogs(:welcome_blog) }

  it 'Blog not changed, so can close' do
    op = PostTestUpdateOp::Close.present(id: blog.id, current_user: current_user.id)
    op.contract.prepopulate!(params: {id: blog.id, current_user: current_user.id})

    res, op = PostTestUpdateOp::Close.run(id: blog.id, blog: {post_attributes: {title: op.contract.post.title, locale: op.contract.post.locale, author: {id: op.contract.post.author.id }, article: op.contract.post.article, tags: op.contract.post.tags}}, current_user: current_user.id)

    res.must_equal true
  end

  it 'Blog changed, so close after confirm' do
    op = PostTestUpdateOp::Close.present(id: blog.id, current_user: current_user.id)
    op.contract.prepopulate!(params: {id: blog.id, current_user: current_user.id})

    res, op = PostTestUpdateOp::Close.run(id: blog.id, blog: {post_attributes: {title: 'Welkom #2', locale: op.contract.post.locale, author: {id: op.contract.post.author.id }, article: op.contract.post.article, tags: op.contract.post.tags}}, current_user: current_user.id)

    res.must_equal false
  end

  it 'Blog tags changed, so close after confirm' do
    op = PostTestUpdateOp::Close.present(id: blog.id, current_user: current_user.id)
    op.contract.prepopulate!(params: {id: blog.id, current_user: current_user.id})

    res, op = PostTestUpdateOp::Close.run(id: blog.id, blog: {post_attributes: {title: 'Welkom #2', locale: op.contract.post.locale, author: {id: op.contract.post.author.id }, article: op.contract.post.article, tags: op.contract.post.tags.push({tag: 'rood'})}}, current_user: current_user.id)

    res.must_equal false
  end

  it 'Blog changed, can close after confirmation' do
    op = PostTestUpdateOp::Close.present(id: blog.id, current_user: current_user.id)
    op.contract.prepopulate!(params: {id: blog.id, current_user: current_user.id})

    res, op = PostTestUpdateOp::Close.run(id: blog.id, confirmed: 'true', blog: {post_attributes: {title: 'Welkom #2', locale: op.contract.post.locale, author: {id: op.contract.post.author.id }, article: op.contract.post.article, tags: op.contract.post.tags}}, current_user: current_user.id)

    res.must_equal true
  end


end