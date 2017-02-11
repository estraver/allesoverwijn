require 'test_helper'

require 'post/operations'
require 'abstract_post/property_type'
require 'abstract_post/properties'
require 'post_util/close'

class PostCloseTest < MiniTest::Spec
  class PostTestBaseOp < Post::Base
    include Model
    include AbstractPost::Properties
    # include PostUtil::Close

    model Blog

    contract PostForm

    properties AbstractPost::PropertyType.find(Blog), property: :post

  end

  class PostTestCloseOp < PostTestBaseOp
    include Callback, Dispatch
    include PostUtil::Close

    def model!(params)
      params.has_key?(:id) ? Blog.find(params[:id]) : Blog.new
    end

  end

  let (:current_user) { users(:admin) }
  let (:blog) { blogs(:welcome_blog) }

  it 'Blog not changed, so can close' do
    params = ActionController::Parameters.new(
        {id: blog.id, current_user: current_user}
    )

    op = PostCloseTest::PostTestCloseOp.present(params)
    op.contract.prepopulate!(params: params)

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

    res, op = PostCloseTest::PostTestCloseOp.run(params)

    res.must_equal true
  end

  it 'Blog tags changed, so close after confirm' do
    params = ActionController::Parameters.new(
        {id: blog.id, current_user: current_user}
    )

    op = PostCloseTest::PostTestCloseOp.present(params)
    op.contract.prepopulate!(params: params)

    params = ActionController::Parameters.new(
        { id: blog.id,
          blog: {
              post_attributes: {
                  title: op.contract.post.title,
                  locale: op.contract.post.locale,
                  author_attributes: {
                      id: op.contract.post.author.id
                  },
                  article: op.contract.post.article,
                  tags_attributes: op.contract.post.tags.map { |tag| {tag: tag.tag} } << {tag: 'kleur'},
                  retained_picture: ''
              }
          },
          current_user: current_user.id
        }
    )

    res, op = PostCloseTest::PostTestCloseOp.run(params)

    res.must_equal false

  end

  it 'Blog changed, so close after confirm' do
    params = ActionController::Parameters.new(
        {id: blog.id, current_user: current_user}
    )

    op = PostCloseTest::PostTestCloseOp.present(params)
    op.contract.prepopulate!(params: params)

    params = ActionController::Parameters.new(
        { id: blog.id,
          blog: {
              post_attributes: {
                  title: 'Welkom #2',
                  locale: op.contract.post.locale,
                  author_attributes: {
                      id: op.contract.post.author.id
                  },
                  article: op.contract.post.article,
                  tags_attributes: op.contract.post.tags.map { |tag| {tag: tag.tag} },
                  retained_picture: ''
              }
          },
          current_user: current_user.id
        }
    )

    res, op = PostCloseTest::PostTestCloseOp.run(params)

    res.must_equal false
  end

  it 'Blog changed, can close after confirmation' do
    params = ActionController::Parameters.new(
        {id: blog.id, current_user: current_user}
    )

    op = PostCloseTest::PostTestCloseOp.present(params)
    op.contract.prepopulate!(params: params)

    params = ActionController::Parameters.new(
        { id: "#{blog.id}",
          confirmed: 'true',
          blog: {
              post_attributes: {
                  title: 'Welkom #2',
                  locale: op.contract.post.locale,
                  author_attributes: {
                      id: op.contract.post.author.id
                  },
                  article: op.contract.post.article,
                  tags_attributes: op.contract.post.tags.map { |tag| {tag: tag.tag} },
                  retained_picture: ''
              }
          },
          current_user: current_user.id
        }
    )

    res, op = PostCloseTest::PostTestCloseOp.run(params)

    res.must_equal true

  end


end