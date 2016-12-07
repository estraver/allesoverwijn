class PostAttachment < Paperdragon::Attachment
  def build_uid(style, file)
    "posts/#{@options[:model].model.model_name.name.downcase}/#{style}-#{Time.now.to_i}-#{file.original_filename}"
  end
end