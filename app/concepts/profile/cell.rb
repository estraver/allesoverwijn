class Profile::Cell < Cell::Concept
  include Cell::ListCell

  def show
    render
  end

  def section
    @options[:section] || links.first
  end

  def user
    @options[:user]
  end

  def object
    @options[:object]
  end

  class Edit < self
    self.classes = %w(user-profile-sidebar)

    def name
      'edit'
    end

    def links
      [:contact, :bio, :favorites, :friends]
    end

    def url(link)
      [:edit, user, object, link]
    end

    def title(title)
      _("views.profile.edit.#{title}")
    end

    class Link < self
      def show
        self.class.classes = [section]
        render :link
      end
    end
  end

  class Show < self
    self.classes = %w(user-profile-tabs)

    def name
      'show'
    end

    def links
      [:contact, :bio, :activities, :friends]
    end

    def url(link)
      [user, object, link]
    end

    def title(title)
      _("views.profile.show.#{title}")
    end

    class Link < self
      def show
        self.class.classes = [section]
        render :link
      end
    end
  end

end
