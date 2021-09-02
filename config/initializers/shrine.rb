require "shrine"
require "shrine/storage/file_system"

if Rails.env.test?
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
else
  require "shrine/storage/s3"
  s3_options = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:            ENV['AWS_REGION'],
    bucket:            ENV['AWS_BUCKET']
  }
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_options)
  }
end

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
Shrine.plugin :validation_helpers
Shrine.plugin :validation