module Blog::Cell
  class Edit < Trailblazer::Cell
    include SimpleForm::ActionViewExtensions::FormHelper

    def operation
      context[:operation]
    end

  end
end