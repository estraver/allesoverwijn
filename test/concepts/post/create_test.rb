require 'test_helper'
require 'post/operations'
require 'abstract_post/property_type'
require 'abstract_post/properties'

class PostCreateTest < MiniTest::Spec
  # Because Post is een abstract concept, we need to use a specific model for testing with Post
  # For testing purposes we create a specific operation with Blog as a model
  class PostTestCreateOp < Post::Base
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
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Welkom',
                article: '<p>Dit is de welkomst blog van allesoverwijn.</p> <p>Allesoverwijn is de community waar je alles over wijn kan vinden en schrijven!</p><p><br>Zo even een kleine aanpassing in het <b>vet</b><br></p>',
                author_attributes: {
                    id: current_user.id.to_s
                },
                locale: 'nl',
                retained_picture: ''
            }
        },
         current_user: current_user.id

    )


    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.persisted?.must_equal true
    op.model.post.post_contents.size.must_equal 1
    op.model.post.post_contents.first.author.id.must_equal current_user.id
  end

  it 'Blog is created with valid properties' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id
                },
                retained_picture: '',
                article: blog_article,
                published: 'false',
                comments: 'allowed'
            }
        },
        current_user: current_user
    )
    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').must_be_instance_of ::Property
    op.model.post.post_contents.first.properties.find_by_name('comments').must_be_instance_of ::Property
  end

  it 'Blog is created, but not published' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                published: 'false',
                comments: 'allowed',
                retained_picture: ''
            },
            scheduling: 'auto'
        },
        current_user: current_user.id.to_s
    )
    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').value.must_equal 'false'
    op.model.post.post_contents.first.properties.find_by_name('published_on').must_be_nil
  end

  it 'Blog is created and published today' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                published: 'true',
                comments: 'allowed',
                retained_picture: ''
            },
            scheduling: 'auto'
        },
        current_user: current_user.id
    )

    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').value.must_equal 'true'
    op.model.post.post_contents.first.properties.find_by_name('published_on').value.must_equal Date.today.to_s
  end

  it 'Blog is created and is to be published tomorrow' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                retained_picture: '',
                published: 'true',
                comments: 'allowed',
                published_on: Date.tomorrow.to_s
            },
            scheduling: 'manual'
        },
        current_user: current_user
    )
    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.post_contents.first.properties.find_by_name('published').value.must_equal 'true'
    op.model.post.post_contents.first.properties.find_by_name('published_on').value.must_equal Date.tomorrow.to_s
  end

  it 'Blog is created with a new tag' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                retained_picture: '',
                published: 'true',
                comments: 'allowed',
                published_on: Date.today.to_s,
                tags_attributes: [{tag: 'rood'}, {tag: 'wit'}]
            },
            scheduling: 'manual'
        },
        current_user: current_user
    )

    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.post_contents.first.tags.find_by_tag('wit').wont_be_nil
    op.model.post.post_contents.first.tags.find_by_tag('rood').wont_be_nil
  end

  it 'Blog is created with a existing tag' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                retained_picture: '',
                published: 'true',
                comments: 'allowed',
                published_on: Date.today.to_s,
                tags_attributes: [{tag: 'wijn'}]
            },
            scheduling: 'manual'
        },
        current_user: current_user
    )
    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.post_contents.first.tags.find_by_tag('wijn').wont_be_nil
    op.model.post.post_contents.first.tags.find_by_tag('wijn').id.must_equal wijn_tag.id
  end

  it 'Blog is created with a category' do
    params = ActionController::Parameters.new(
        blog: {
            post_attributes: {
                title: 'Blog Test #1',
                locale: 'nl',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                retained_picture: '',
                published: 'true',
                comments: 'allowed',
                published_on: Date.today.to_s,
                tags_attributes: [{tag: 'wijn'}],
                categories_attributes: [{id: cat_grape.id}, {id: cat_grape_white.id}]
            },
            scheduling: 'manual'
        },
        current_user: current_user
    )
    res, op = PostTestCreateOp.run(params)

    res.must_equal true
    op.model.post.categories.find(cat_grape.id).wont_be_nil
    op.model.post.categories.find(cat_grape_white.id).wont_be_nil
  end

  it 'Blog as from' do
    params = ActionController::Parameters.new(
      current_user: current_user
    )

    op = PostTestCreateOp.present(params)
    op.contract.prepopulate!(params: params)

    op.contract.post.wont_be_nil
  end

end
