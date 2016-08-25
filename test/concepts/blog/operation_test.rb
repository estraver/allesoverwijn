require 'test_helper'

class BlogCreateTest < MiniTest::Spec
  let (:current_user) { users(:admin) }

  describe 'Create new blog ' do
    it 'when blog has no title' do
      res, op = Blog::Create.run(blog: {post: {title: ''}}, current_user: current_user)

      res.must_equal false
      op.errors.to_s.must_equal "{:\"post.title\"=>[\"must be filled\"]}"
      # op.persisted?.must_equal false

    end
  end


end