require 'profile/cell/layout/show'

module Profiles
  class ContactsController < ProfilesController
    respond_to :html, :json

    def edit
      form Profile::Contact::Update
      if request.xhr?
        render html: cell(Profile::Contact::Cell::Edit, @model, context: {current_user: current_user, operation: @operation})
      else
        render html: cell(Tabs::TabsCell, @model, tabs: tabs, context: {current_user: current_user, section: Profile::Contact::Cell::Edit, html_options: {class: 'nav-stacked'}, url_options: {profile_id: @model.id, user_id: @model.user.id}, title: _('view.profile.edit.header'), operation: @operation}, layout: Profile::Cell::Layout::Edit).(:pills_and_stacked), layout: :default
      end

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
        render html: cell(Tabs::TabsCell, op.model, tabs: tabs, context: context, layout: Profile::Cell::Layout::Show).(:pills), layout: :default
      end
    end

    def context
      {current_user: current_user, section: Profile::Contact::Cell::Show, html_options: {class: 'nav-underline'}, url_options: {profile_id: @model.id, user_id: @model.user.id}, title: _('view.profile.show.header')}
    end

  end
end
