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
      present Profile::Bio::Update
    end
  end
end
