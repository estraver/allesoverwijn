class ProfileAttachment < Paperdragon::Attachment
  def build_uid(style, file)
    "profiles/#{style}-#{file.original_filename}"
  end
end