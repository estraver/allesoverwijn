require_dependency 'user_util/current_user'
require_dependency 'recollect/twin'
# require_dependency 'abstract_category/abstract_category'
require_dependency 'category/category_form'

class Category < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model, Policy, Dispatch
    include UserUtil::CurrentUser

    model Category, :create
    # policy Category::Policy, :create? TODO

    contract CategoryForm

    def process(params)
      validate(params[:category]) do | contract |
        # dispatch!(:before_save)
        contract.save
      end
    end

    private

    def params!(params)
      if params.has_key? :category
        params[:category].merge! category_names: []

        category_name = {}
        %w(name locale).each do | prop |
          category_name[prop.to_sym] = params[:category][prop.to_sym]
        end

        params[:category][:category_names].push category_name
      end

      params
    end
  end

  class Update < Create
    action :update
    # policy Category::Policy, :update? TODO
  end

  class Delete < Trailblazer::Operation
    include Model, Policy
    include UserUtil::CurrentUser

    model Category, :find
    # policy Category::Policy, :destroy? TODO

    contract do
      property :id

      validation :default do
        configure do
          option :form

          config.messages_file = 'config/dry_error_messages.yml'

          def category_not_used?
            form.model.posts.empty?
          end

          def category_childs_not_used?
            used_categories = []
            build_used_child_categories(form.model, used_categories)

            used_categories.empty?
          end

          private

          def build_used_child_categories(category, used_categories = [])
            return if category.child_categories.size.eql? 0

            category.child_categories.collect do | child_category |
              used_categories.push child_category unless child_category.posts.empty?

              build_used_child_categories child_category, used_categories
            end

            used_categories
          end
        end

        required(:id).filled(:category_not_used?, :category_childs_not_used?)
      end

    end

    def process(params)
      validate(params) do | contract |
        contract.model.destroy
      end

    end
  end

  class Show < Create
    action :find
  end

  class Index < Trailblazer::Operation
    include Collection
    include Model
    include UserUtil::CurrentUser

    model Category

    collection :all do
      include Recollect::Collection::Twin

      scope -> { :all }
      # twin AbstractCategory::Entry
    end
  end
end