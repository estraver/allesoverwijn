module Cell
  module DateCell
    # def self.included(base)
    #   base.send :include, ActionView::Helpers::DateHelper
    # end

    def self.property(field)
      Module.new do
        include ActionView::Helpers::DateHelper

        define_method(field.to_sym) do |*args|
          begin
            time_tag(super(*args), format: AppConfig.date.short)
          rescue
            nil
          end
        end
      end
    end
  end
end