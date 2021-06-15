require "rails_helper"

RSpec.describe "Posts requests", type: :request do
  describe "POST /posts" do
    let(:file) { fixture_file_upload("test_image_1.jpeg", "image/jpeg") }
    let(:params) do
      {
        post: {
          title: "title 1",
          body: "body 1",
          image: file
        }
      }
    end
    let(:expected_body) do
      {
        title: "title 1",
        body: "body 1"
      }
    end

    before { post("/posts", params: params) }

    it "returns status 201" do
      expect(response.status).to eq(201)
    end

    it "post has attached image file" do
      expect(Post.last.image.metadata["filename"]).to eq("test_image_1.jpeg")
    end
  end

  describe "PUT /posts" do
    let(:post) { create :post }
    let(:file) { fixture_file_upload("test_image_2.jpeg", "image/jpeg") }
    let(:params) do
      {
        post: {
          title: "title updated",
          body: "body updated",
          image: file
        }
      }
    end

    subject { put("/posts/#{post.id}", params: params) }

    it "works and return status 200" do
      subject
      expect(response.status).to eq(200)
    end

    it "works and return json with proper keys" do
      expect { subject }.to change { post.reload.image.metadata["filename"] }
        .from("test_image_1.jpeg"). to("test_image_2.jpeg")
    end
  end
end
