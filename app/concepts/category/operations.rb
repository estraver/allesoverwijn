require_dependency 'user_util/current_user'
require_dependency 'recollect/twin'
require_dependency 'abstract_category/abstract_category'
require_dependency 'category/category_contract'

class Category < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model, Policy, Dispatch
    include UserUtil::CurrentUser


    model Category, :create
    # policy Category::Policy, :create? TODO

    callback :before_save do
      on_change :update_category!
    end

    contract CategoryContract

    # contract do
    #   property :name
    #   property :locale
    #   property :parent_category
    #   collection :child_categories
    #
    #   validation :default do
    #     validates :name, presence: true, allow_blank: false
    #     validates :locale, presence: true, allow_blank: false
    #   end
    # end

    def process(params)
      validate(params[:category]) do
        dispatch!(:before_save)
        model.save(params[:category])
      end
    end

    private

    attr_reader :category

    def setup_model!(params)
      super(params)
      @category ||= AbstractCategory::Entry.new(model, current_user: current_user)
      @category.sync # Sync defaults to model
    end

    def update_category!(contract, op)
      @category.name = contract.name
      @category.locale = contract.locale
      @category.parent_category = contract.parent_category

      AbstractCategory::Entry::NameChange.new(@category).()
      @category.sync
    end

  end

  class Update < Create
    action :update
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
      twin AbstractCategory::Entry
    end
  end
end