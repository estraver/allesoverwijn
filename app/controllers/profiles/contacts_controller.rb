require 'profile/cell/layout/show'

module Profiles
  class ContactsController < ProfilesController
    respond_to :html, :json, :js

    def edit
      form Profile::Contact::Update
    end

    def update
      respond Profile::Contact::Update do | op, format |
        format.json { render_json op, 'profile.contacts.update' }
      end
    end

    def show
      op = present(Profile::Contact::Show)

      if request.xhr?
        render html: cell(Profile::Contact::Cell::Show, op.model, context: {current_user: current_user, html_options: {class: 'nav-underline'}, url_options: {profile_id: @model.id, user_id: @model.user.id}})
      else
        render html: cell(Tabs::TabsCell, op.model, tabs: tabs, context: context, layout: Profile::Cell::Layout::Show), layout: :default
      end
    end

    def context
      {current_user: current_user, section: Profile::Contact::Cell::Show, html_options: {class: 'nav-underline'}, url_options: {profile_id: @model.id, user_id: @model.user.id}, title: _('view.profile.show.header')}
    end

  end
end
