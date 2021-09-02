class Post < ApplicationRecord
  include ImageUploader::Attachment(:image)
end
