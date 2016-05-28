class PostAttachment < Paperdragon::Attachment
  def build_uid(style, file)
    "posts/#{style}-#{Time.now.to_i}-#{file.original_filename}"
  end
end