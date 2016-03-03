require_dependency 'profile/bio/operations'

module Profiles
  class BiosController < ProfilesController
    def edit
      super
      form Profile::Bio::Update
    end
  end
end
