require_dependency 'profile/contact/operations'

module Profiles
  class ContactsController < ProfilesController
    respond_to :html, :json

    def edit
      form Profile::Contact::Update
    end

    def update
      respond Profile::Contact::Update do | op, format |
        format.json { render_json op, 'profile.contacts.update' }
      end
    end

    def show
      present Profile::Contact::Update
    end

  end
end
