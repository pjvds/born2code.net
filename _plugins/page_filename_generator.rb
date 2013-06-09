module Jekyll

  class PageFilenameGenerator < Generator
    safe true

    def generate(site)
      site.posts.each do |post|
        post.data['filename'] = post.name
      end
    end
  end

end
