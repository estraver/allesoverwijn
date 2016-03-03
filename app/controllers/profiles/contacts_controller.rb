require_dependency 'profile/contact/operations'

module Profiles
  class ContactsController < ProfilesController
    def edit
      super
      form Profile::Contact::Update
    end
  end
end
