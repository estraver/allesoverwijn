require 'test_helper'

class DeleteCategoryTest < MiniTest::Spec
  describe 'Category' do
    let (:category) { categories(:cat_druif) }
    let (:category_child) { categories(:cat_wit) }

    let (:category_used) { categories(:cat_wine) }

    let (:current_user) { users(:admin) }

    it 'do no destroy when used in post' do
      res, op = Category::Delete.run(id: category_used.id, current_user: current_user.id)

      res.must_equal false
      op.contract.errors[:id].must_include 'Category.still.used.in.post'
      op.contract.errors[:id].must_include 'Category.child.still.used.in.post'
    end

    it 'destroys as child category' do
      parent_id = category_child.parent_category.id
      res, op = Category::Delete.run(id: category_child.id, current_user: current_user.id)

      res.must_equal true
      op.model.destroyed?.must_equal true
      Category.find(parent_id).wont_be_nil
    end

    it 'destroys as a root category with childs' do
      child_id = category_child.id
      res, op = Category::Delete.run(id: category.id, current_user: current_user.id)

      res.must_equal true
      op.model.destroyed?.must_equal true
      assert_raises ActiveRecord::RecordNotFound do
        Category.find(child_id)
      end
    end

  end
end