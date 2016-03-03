module Cell
  module CreatedAtCell
    def self.included(base)
      base.send :include, ActionView::Helpers::DateHelper
    end

    private

    def created_at
      time_tag(super, format: AppConfig.date.short)
    end

  end
end
