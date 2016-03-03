require_dependency 'profile/photo/operations'

module Profiles
  class PhotosController < ProfilesController
    respond_to :html, :json

    def edit
      form Profile::Photo::Update
    end

    def update
      respond Profile::Photo::Update do | op, format |
        format.json { render_json op, 'profile.photo.update' }
        format.html
      end
    end


  end
end
