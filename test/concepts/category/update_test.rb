require 'test_helper'

class UpdateCategoryTest < MiniTest::Spec
  describe 'Category' do
    let (:category) { categories(:cat_druif) }
    let (:current_user) { users(:admin) }

    it 'updates name with same locale' do
      op = Category::Update.present(id: category.id, current_user: current_user.id)
      op.contract.prepopulate!(params: {id: category.id, current_user: current_user.id})

      names_count = category.category_names.size

      res, op = Category::Update.run(id: category.id, current_user: current_user.id, category: {name: 'Druiven', locale: 'nl'})

      res.must_equal true
      op.model.category_names.size.must_equal names_count
    end

    it 'adds a new translation for category' do
      op = Category::Update.present(id: category.id, current_user: current_user.id)
      op.contract.prepopulate!(params: {id: category.id, current_user: current_user.id})

      names_count = category.category_names.size

      res, op = Category::Update.run(id: category.id, current_user: current_user.id, category: {name: 'Raisin', locale: 'fr'})

      res.must_equal true
      op.model.category_names.size.must_equal names_count + 1
    end
  end
end