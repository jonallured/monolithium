require "rails_helper"

describe BlogPost do
  describe "validation" do
    context "without required attrs" do
      it "is not valid" do
        blog_post = BlogPost.new
        expect(blog_post).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        blog_post = BlogPost.new(
          number: 1,
          published_on: Date.current,
          summary: "Hi.",
          title: "Short Post",
          url: "https://www.jonallured.com/posts/2007/01/01/short-post.html"
        )
        expect(blog_post).to be_valid
      end
    end
  end
end
