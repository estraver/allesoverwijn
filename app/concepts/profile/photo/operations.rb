require 'profile/operations'
require 'transfer/upload'
require 'attachment/profile_attachment'

class Profile < ActiveRecord::Base
  module Photo
    class Create < Profile::Create
      include Model, Trailblazer::Operation::Policy
      # include Representer::Deserializer::Hash, Responder, Representer
      include Dispatch

      model Profile, :create
      policy Profile::Policy, :create?
    end

    class Update < Create
      extend Representer::DSL
      include Representer::Rendering, Responder, Transfer::Upload

      action :update
      policy Profile::Policy, :owner?

      image :photo, thumbs: [{name: :thumb, size: '50x50#'}, {name: :profile_picture, size: '159x159#'}], thumb_class: ProfileAttachment

    end
  end
end