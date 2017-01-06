
module UserUtil
  module Guest
    module Profile
      class << self

        def language
          I18n.locale
        end
      end
    end
  end
end
