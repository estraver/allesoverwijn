require 'test_helper'

class ContentFormTest < MiniTest::Spec
  let (:form) { AbstractPost::ContentForm.new(Post.new) }
  let (:valid_article) { '<p>Een tekst die lang genoeg is voor validatie. Oftewel minimaal 10 woorden en één regel </p>' }

  describe 'Content is not valid' do
    it 'when content has empty title' do
      res = form.validate(title: '')

      res.must_equal false
      form.errors[:title].must_equal ['must be filled']
    end

    it 'when content has empty locale' do
      res = form.validate(locale: '')

      res.must_equal false
      form.errors[:locale].must_equal ['must be filled']
    end

    it 'when content has empty author' do
      res = form.validate(author: '')

      res.must_equal false
      form.errors[:author].must_equal ['must be filled']
    end

    it 'when content has empty aricle' do
      res = form.validate(article: '')

      res.must_equal false
      form.errors[:article].must_equal ['must be filled']
    end

    it 'when content has no values' do
      res = form.validate({})

      res.must_equal false
      form.errors[:title].must_equal ['is missing']
      form.errors[:author].must_equal ['is missing']
      form.errors[:article].must_equal ['is missing']
      form.errors[:locale].must_equal ['is missing']
    end

    it 'when title is not unique for locale' do
      welcome_post = posts(:welcome).post_contents.first
      user = users(:admin)

      res = form.validate(title: welcome_post.title, locale: welcome_post.locale, author: user, article: valid_article )

      res.must_equal false
      form.errors[:title].must_equal ['Post.title.not.unique']
    end

    it 'when locale is not in supported languages' do
      user = users(:admin)
      res = form.validate(title: 'Title #1', locale: 'de', author: user, article: valid_article )

      res.must_equal false
      form.errors[:locale].must_equal ['must be one of: nl, en, fr']
    end

    it 'when article is to short of words and lines' do
      user = users(:admin)
      res = form.validate(title: 'Title #1', locale: 'en', author: user, article: 'no line and too short' )

      res.must_equal false
      form.errors[:article].must_equal %w(Post.article.less.than.2.lines Post.article.less.than.10.words)

    end

  end

  describe 'Content is valid' do
    it 'when all fields are valid' do
      user = users(:admin)
      res = form.validate(title: 'Title #1', author: user, locale: 'en', article: valid_article)

      res.must_equal true
      form.errors.must_be_empty
    end
  end


end