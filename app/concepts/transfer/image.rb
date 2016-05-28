class Image
  # include ActiveModel::Serialization
  include ActiveRecord::Attributes
  include ActiveRecord::AttributeDecorators
  include ActiveRecord::AttributeMethods::Serialization

  attr_accessor :image_meta_data

  serialize :image_meta_data

  # def initialize(*args)
  #   Rails.logger.info 'Image::initilize'
  #   Rails.logger.info args
  #   # @image_meta_data = image_meta_data
  # end
end