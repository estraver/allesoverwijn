require 'user_util/current_user'
require 'post/published_collection'
require 'post/post_representer'
require 'transfer/upload'
# require 'representable/json'

class Post::Base < Trailblazer::Operation
  include Callback, Dispatch
  include UserUtil::CurrentUser

  # builds -> (params) do
  #   JSON if params[:format] =~ 'json'
  # end

  callback :before_save do
    on_change :categories_change!
  end

  callback :after_save do
  end

  def process(params)
    # Dirty trick to get te defined model of the operation
    # model_name = self.class.class_name.to_s.downcase.to_sym
    model_name = model.class.to_s.downcase.to_sym
    validate(params[model_name]) do | contract |
      dispatch!(:before_save)
      contract.save
      dispatch!(:after_save)
    end

  end

  private

  def params!(params)
    # Dirty trick to get te defined model of the operation
    model_key = self.class.model_class.to_s.downcase.to_sym

    # model_key = model.class.to_s.downcase.to_sym

    if params.has_key? model_key

      params[model_key][:post_attributes].merge! published_on: Date.today if params[model_key][:scheduling].eql? 'auto' and params[model_key][:post_attributes][:published].eql? 'true'

      params[model_key][:post_attributes].merge! post_contents: []
      post_content = {}
      %w(id title article locale author_attributes).each do | prop |
        post_content[prop.to_sym] = params[model_key][:post_attributes][prop.to_sym]
      end

      post_content[:properties] = self.properties.select { | property | !params[model_key][:post_attributes][property.name].nil? }.map do | property |
        { name: property.name.to_s, value: params[model_key][:post_attributes][property.name] }
      end

      unless params[model_key][:post_attributes][:tags_attributes].nil?
        params[model_key][:post_attributes][:tags_attributes] = Hash[params[model_key][:post_attributes][:tags_attributes].each_with_index.map { |tag,index| [index, tag] }]
      end

      unless params[model_key][:post_attributes][:categories_attributes].nil?
        params[model_key][:post_attributes][:categories_attributes] = Hash[params[model_key][:post_attributes][:categories_attributes].each_with_index.map { |category,index| [index, category] }]
      end

      post_content[:tags_attributes] = params[model_key][:post_attributes][:tags_attributes] unless params[model_key][:post_attributes][:tags_attributes].nil?

      params[model_key][:post_attributes][:post_contents].push post_content

      params[model_key][:post_attributes][:picture_meta_data] = {}
    else
      params[model_key] = {}
      params[model_key][:post_attributes]= {}
      params[model_key][:post_attributes].merge! post_contents: []
    end

    params
  end

  def categories_change!(twin, options)

  end

  # class JSON < self
  #   extend Representer::DSL
  #   include Representer::Rendering, Responder
  #   # include Representable::JSON
  #
  #   representer PostRepresenter
  # end

end


class Post::Upload < Post::Base
  extend Representer::DSL
  include Representer::Rendering, Responder, Transfer::Upload, Model

  model Post, :update
  # policy Post::Policy, :owner?

  image :picture, thumbs: [{name: :header, size: '1170x660#'}, {name: :sidebar, size: '128x128#'}], thumb_class: PostAttachment

end

# class Post::Index < Trailblazer::Operation
#   include Collection
#   include Model
#   include UserUtil::CurrentUser
#   include Policy
#
#   collection :published, collection: PublishedCollection
# end