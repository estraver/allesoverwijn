require_dependency 'profile/photo/operations'

module Profiles
  class PhotosController < ProfilesController
    respond_to :html, :json

    def create
      respond Profile::Photo::Update do | op, format |
        format.json { render_json op, 'profile.photo.update' }
        format.html
      end
    end

  end
end
