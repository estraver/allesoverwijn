require_dependency 'profile/bio/operations'

module Profiles
  class BiosController < ProfilesController

    respond_to :html, :json

    def edit
      form Profile::Bio::Update
    end

    def update
      respond Profile::Bio::Update do | op, format |
        format.json {
          render_json op, 'profile.update.bio'
        }
        format.js { render :edit }
      end
    end

    def show
      op = present(Profile::Bio::Show)
      if request.xhr?
        render html: cell(Profile::Bio::Cell::Show, op.model, context: {current_user: current_user, html_options: {}, url_options: {profile_id: op.model.id, user_id: op.model.user.id}})
      else
        render html: cell(Tabs::TabsCell, op.model, tabs: tabs, context: {current_user: current_user, section: Profile::Bio::Cell::Show, html_options: {class: 'nav-underline'}, url_options: {profile_id: op.model.id, user_id: op.model.user.id}, title: _('view.profile.show.header')}, layout: Profile::Cell::Layout::Show), layout: :default
      end
    end
  end
end
