# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { "test title" }
    body { "test body" }
    image { File.open("spec/fixtures/files/test_image_1.jpeg", "rb") }
  end
end
