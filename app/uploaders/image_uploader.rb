class ImageUploader < Shrine
  Attacher.validate do
    validate_extension %w[jpeg]
  end
end
