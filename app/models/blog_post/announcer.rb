class BlogPost::Announcer < ActiveRecord::AssociatedObject
  def run
    thumb = BlueskyApi.upload_image(blog_post.image_url)

    embed_options = {
      description: blog_post.summary,
      thumb: thumb,
      title: blog_post.title,
      uri: blog_post.url
    }

    embed = BlueskyApi.setup_embed(embed_options)
    message = [blog_post.title, blog_post.url].join(" ")

    BlueskyApi.announce(message, embed)

    blog_post.update(
      announced_at: Time.now
    )
  end
end
