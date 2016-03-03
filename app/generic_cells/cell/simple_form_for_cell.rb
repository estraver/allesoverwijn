module Cell
  module SimpleFormForCell
    extend ActiveSupport::Concern

    included do
      include ActionView::Helpers::FormHelper
      include ActionView::RecordIdentifier
      include SimpleForm::ActionViewExtensions::FormHelper
    end

    def show
      render
    end

    def form
      options[:form]
    end
  end
end
