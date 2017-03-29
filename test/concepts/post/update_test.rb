require 'test_helper'
require 'post/operations'
require 'abstract_post/property_type'
require 'abstract_post/properties'

class PostUpdateTest < MiniTest::Spec
  class PostTestCreateOp < Post::Base
    include Model
    include AbstractPost::Properties

    model Blog, :create

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post
  end

  class PostTestUpdateOp < PostTestCreateOp
    action :update
  end

  let (:current_user) { users(:admin) }
  let (:blog_article) { '<p>This is the welcome blog all about wine.</p> <p>All About Wine is the community where you can find and write all about wine!</p>' }
  let (:blog) { blogs(:welcome_blog) }

  it 'Blog title is updated, no translation' do
    params = ActionController::Parameters.new(
        id: blog.id,
        current_user: current_user
    )

    op = PostTestUpdateOp.present(params)
    op.contract.prepopulate!(params: params)

    params = ActionController::Parameters.new(
        id: blog.id,
        blog: {
            post_attributes: {
                title: 'Blog Test #2',
                locale: 'nl',
                author_attributes: {
                    id: op.contract.post.author.id.to_s
                },
                article: op.contract.post.article,
                retained_picture: ''
            }
        },
        current_user: current_user
    )

    res, op = PostTestUpdateOp.run(params)

    res.must_equal true
    op.model.persisted?.must_equal true
    op.model.post.post_contents.size.must_equal 1
    op.model.post.post_contents.first.title.must_equal 'Blog Test #2'
  end

  it 'Blog is updated with a new translation' do
    params = ActionController::Parameters.new(
        id: blog.id,
        current_user: current_user
    )

    op = PostTestUpdateOp.present(params)
    op.contract.prepopulate!(params: params)

    params = ActionController::Parameters.new(
        id: blog.id,
        blog: {
            post_attributes: {
                title: 'Welcome',
                locale: 'en',
                author_attributes: {
                    id: current_user.id.to_s
                },
                article: blog_article,
                retained_picture: ''
            }
        },
        current_user: current_user
    )

    res, op = PostTestUpdateOp.run(params)

    res.must_equal true

    op.model.persisted?.must_equal true
    op.model.post.post_contents.size.must_equal 2
  end

  it 'Blog updated' do

    params = ActionController::Parameters.new(
        {id: '70261360',
         published_on_year: '2016',
         published_on_month: '9',
         published_on_day: '17',
         blog: {
             post_attributes: {
                 id: '936075699',
                 title: 'Welkom',
                 article: '<p>Dit is de welkomst blog van allesoverwijn.</p> <p>Allesoverwijn is de community waar je alles over wijn kan vinden en schrijven!</p><p><br>Zo even een kleine aanpassing in het <b>vet</b><br></p>',
                 author_attributes: {
                     id: '135138680'
                 },
                 locale: 'nl',
                 retained_picture: '',
                 category_ids: ['188715994', '267898103'],
                 tags_attributes: [{tag: 'druiven'}, {tag: 'wijn'}],
                 published_on: '2016-09-17T20:23:18+00:00'
             }
         },
         current_user: current_user.id
        }
    )

    res, op = PostTestUpdateOp.run(params)

    res.must_equal true

  end

end