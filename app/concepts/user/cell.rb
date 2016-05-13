class User::Cell < Cell::Concept
  property :name
  property :created_at
  property :roles

  def show
    render
  end

  class Sidebar < Cell::Concept
    property :name
    property :created_at
    property :roles
    property :profile

    inherit_views User::Cell

    include ::Cell::CreatedAtCell

    def show
      render :sidebar
    end

    def online?
      true # FIXME:
    end

    def editable?
      parent_controller.send(:action_name).eql? 'edit'
    end


  end

  class Navigation < Cell::Concept
    inherit_views User::Cell

    include Cell::NavigationCell

    self.classes = ['navbar-right']

    def show
      render :navigation
    end

    def user_links
      if tyrant.signed_in?
        NavigationLink.build_links(
            {
                account: {
                    name: 'navigation.account',
                    url: '#',
                    links: {
                      profile: {
                          name: 'navigation.profile',
                          url: user_path(model)
                      },
                      sign_out: {
                          name: 'navigation.sign_out',
                          url: session_path,
                          options: {method: 'delete'}
                      }
                    }
                }
            })

      else
        NavigationLink.build_links(
            {
                login: {
                    name: 'navigation.login',
                    url: new_session_path
                },
                form: {
                    name: 'navigation.sign_up',
                    url: new_registration_path
                }
            })
      end
    end

    def user_languages
      NavigationLink.build_links({
                                     language: {
                                         name: I18n.locale,
                                         url: '#',
                                         icon: ['flag-icon', "flag-icon-#{I18n.locale}"],
                                         links: I18n.available_locales.map { |locale|
                                           {:"#{locale}" => {name: locale, url: url_for(:only_path => true, :locale => locale), icon: ['flag-icon', "flag-icon-#{locale}"]}}
                                         }.reduce({}) { |h,v| h.merge v }
                                     }
                                 })
    end

    private

    def tyrant
      options[:tyrant]
    end
  end
end
