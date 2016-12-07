require 'test_helper'

class CreateCategoryTest < MiniTest::Spec
  describe 'Category' do
    let (:admin) { users(:admin) }
    let (:grape) { categories(:cat_druif) }

    it 'do not create with empty name and locale' do
      res, op = Category::Create.run(current_user: admin.id, category: {name: '', locale: ''})

      res.must_equal false
      op.contract.errors[:name].must_include 'must be filled'
      op.contract.errors[:locale].must_include 'must be filled'
    end

    it 'do not create with wrong locale' do
      res, op = Category::Create.run(current_user: admin.id, category: {name: 'Traube', locale: 'de'})

      res.must_equal false
      op.contract.errors[:locale].must_include 'must be one of: nl, en, fr'
    end

    it 'creates a "root" category' do
      res, op = Category::Create.run(current_user: admin.id, category: {name: 'Wijn', locale: 'nl'})

      res.must_equal true
      op.model.category_names.first.name.must_equal 'Wijn'
    end

    it 'creates a "child" category' do
      res, op = Category::Create.run(current_user: admin.id, category: {name: 'Rood', locale: 'nl', parent_category_id: grape.id})

      res.must_equal true
      op.model.parent_category.id.must_equal grape.id
    end
  end
end