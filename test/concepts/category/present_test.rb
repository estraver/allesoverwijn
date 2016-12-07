require 'test_helper'

class PresentCategoryTest < MiniTest::Spec
  describe 'Category' do
    let (:category) { categories(:cat_druif) }
    let (:current_user) { users(:admin) }

    it 'presents' do
      op = Category::Update.present(id: category.id, current_user: current_user.id)
      op.contract.prepopulate!(params: {id: category.id, current_user: current_user.id})

      op.contract.child_categories.size.must_equal 1
      op.contract.child_categories.first.name.must_equal 'white'
    end
  end
end