require 'recollect/recollect'
require 'recollect/derivative'
require 'recollect/array'

class MostUsedCategoryCollection < Recollect::Collection
  include Derivative
  include Array

  scope -> { joins(:posts).group('categories.id').order('COUNT(posts.id) DESC').limit(10) }
  derivative :name do | current_user:, model:, ** |
    model.category_names.find_by(locale: current_user.profile.language || I18n.locale || I18n.default_locale).name
  end
end