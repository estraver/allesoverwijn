require 'recollect/recollect'
require 'recollect/derivative'
require 'recollect/array'

class TopCategoryCollection < Recollect::Collection
  include Derivative, Array

  scope -> { where('parent_category_id IS NULL') }
  derivative :name do | current_user:, model:, ** |
    model.category_names.find_by(locale: current_user.profile.language || I18n.locale || I18n.default_locale).name
  end
end