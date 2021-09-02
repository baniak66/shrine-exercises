require "rails_helper"

RSpec.describe "Posts requests", type: :request do
  describe "POST /posts" do
    subject(:create_post) { post("/posts", params: params) }

    let(:params) do
      {
        post: {
          title: "new title",
          body: "body",
          image: file
        }
      }
    end
    let(:file) { fixture_file_upload(filename) }
    let(:filename) { "test_image_1.jpeg" }

    it "returns proper response code" do
      create_post
      expect(response.status).to eq(201)
    end

    it "returns proper response code" do
      create_post
      expect(Post.last.image.metadata["filename"]).to eq(filename)
    end

    context "when file with invalid extension" do
      let(:filename) { "sample.png" }
      let(:error_response) { { "image" => ["extension must be one of: jpeg"] } }

      it "returns status 422" do
        create_post
        expect(response.status).to eq(422)
      end

      it "return proper error message" do
        create_post
        expect(JSON.parse(response.body)).to eq(error_response)
      end
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

    subject(:update_post) { put("/posts/#{post.id}", params: params) }

    it "works and return status 200" do
      update_post
      expect(response.status).to eq(200)
    end

    it "works and return json with proper keys" do
      expect { update_post }.to change { post.reload.image.metadata["filename"] }
        .from("test_image_1.jpeg"). to("test_image_2.jpeg")
    end
  end
end