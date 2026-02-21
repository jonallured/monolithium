class BlogPost::Announcer < ActiveRecord::AssociatedObject
  def run
    something = blog_post.to_haha
    BlueSkyApi.create_post(something)
    MastodonApi.create_post(something)
    blog_post.update(
      announced_at: Time.now
    )
  end
end
