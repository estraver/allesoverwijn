module Navigation
  class UserCell < Cell::ViewModel
    include Cell::NavigationCell

    self.classes = ['navbar-right']

    def user_links
      if current_user
        NavigationLink.build_links(
            {
                account: {
                    name: 'navigation.account',
                    url: '#',
                    links: {
                        profile: {
                            name: 'navigation.profile',
                            url: user_path(current_user)
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

    # FIXME: User user locale if user logged in
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

    def current_user
      context[:current_user]
    end
  end
end