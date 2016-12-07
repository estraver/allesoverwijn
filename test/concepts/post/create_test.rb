require 'test_helper'
require 'post/operations'
require 'abstract_post/property_type'
require 'abstract_post/properties'

class PostCreateTest < MiniTest::Spec
  # Because Post is een abstract concept, we need to use a specific model for testing with Post
  # For testing purposes we create a specific operation with Blog as a model
  class PostTestCreateOp < Post::Create
    include Model
    include AbstractPost::Properties

    model Blog, :create

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post
  end

  let (:current_user) { users(:admin) }
  let (:blog_article) { '<p>Dit is een blog tekst dat hoort bij de de test van de update en creatie.</p><p>Twee paragrafen zijn noodzakelijke!</p>' }
  let (:wijn_tag) { tags(:tag_wijn) }
  let (:cat_grape) { categories(:cat_druif) }
  let (:cat_grape_white) { categories(:cat_wit) }

  it 'Blog is created without properties' do

    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article}}, current_user: current_user.id)

    res.must_equal true
    op.model.persisted?.must_equal true
    op.model.post.post_contents.size.must_equal 1
    op.model.post.post_contents.first.author.id.must_equal current_user.id
  end

  it 'Blog is created with valid properties' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'false', comments: 'allowed'}}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').must_be_instance_of ::Property
    op.model.post.post_contents.first.properties.find_by_name('comments').must_be_instance_of ::Property
  end

  it 'Blog is created, but not published' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'false', comments: 'allowed'}, scheduling: 'auto'}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').value.must_equal 'false'
    op.model.post.post_contents.first.properties.find_by_name('published_on').must_be_nil
  end

  it 'Blog is created and published today' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'true', comments: 'allowed'}, scheduling: 'auto'}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').value.must_equal 'true'
    op.model.post.post_contents.first.properties.find_by_name('published_on').value.must_equal Date.today.to_s
  end

  it 'Blog is created and is to be published tomorrow' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'true', comments: 'allowed', published_on: Date.tomorrow.to_s}, scheduling: 'manual'}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').value.must_equal 'true'
    op.model.post.post_contents.first.properties.find_by_name('published_on').value.must_equal Date.tomorrow.to_s
  end

  it 'Blog is created with a new tag' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'true', comments: 'allowed', published_on: Date.today.to_s, tags: [{tag: 'rood'}, {tag: 'wit'}]}, scheduling: 'manual'}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.first.tags.find_by_tag('wit').wont_be_nil
    op.model.post.post_contents.first.tags.find_by_tag('rood').wont_be_nil
  end

  it 'Blog is created with a existing tag' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'true', comments: 'allowed', published_on: Date.today.to_s, tags: [{tag: 'wijn'}]}, scheduling: 'manual'}, current_user: current_user.id)

    res.must_equal true
    op.model.post.post_contents.first.tags.find_by_tag('wijn').wont_be_nil
    op.model.post.post_contents.first.tags.find_by_tag('wijn').id.must_equal wijn_tag.id
  end

  it 'Blog is created with a category' do
    res, op = PostTestCreateOp.run(blog: {post: {title: 'Blog Test #1', locale: 'nl', author: { id: current_user.id }, article: blog_article, published: 'true', comments: 'allowed', published_on: Date.today.to_s, tags: [{tag: 'wijn'}], categories: [{id: cat_grape.id}, {id: cat_grape_white.id}]}, scheduling: 'manual'}, current_user: current_user.id)

    res.must_equal true
    op.model.post.categories.find(cat_grape.id).wont_be_nil
    op.model.post.categories.find(cat_grape_white.id).wont_be_nil
  end

end
