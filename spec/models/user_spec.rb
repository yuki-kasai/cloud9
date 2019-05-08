require 'rails_helper'

RSpec.describe User, type: :model do
  context "postの関連は" do
    it "Userクラスであること" do
      post = Post.create!(user: User.new)
      expect(post.user.class).to eq User
    end
  end
  
  
end
