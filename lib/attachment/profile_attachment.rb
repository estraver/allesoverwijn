class ProfileAttachment < Paperdragon::Attachment
  def build_uid(style, file)
    "profiles/#{@options.model.name}/#{style}-#{file.original_filename}"
  end
end