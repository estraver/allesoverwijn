class PostAttachment < Paperdragon::Attachment
  def build_uid(style, file)
    model = options[:model].model.respond_to?(:page) ? options[:model].model.page : options[:model].model
    "posts/#{model.class.to_s.downcase}/#{style}-#{Time.now.to_i}-#{file.original_filename}"
  end
end