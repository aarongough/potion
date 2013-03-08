What is Potion?
===============

Potion is a simple, clean, and easily extensible static site generator. Potion is designed from the ground up to be friendly to any tech-savvy person running a blog or website of almost any kind. 

Running a website via a static site generator is great because all your assets and files are able to be easily version-controlled and backed-up. Hosting for static sites is inexpensive, and a server that's only serving static files can handle a lot more load given the same resouces as compared to a server that is serving a site made in a dynamic CMS.

Potion was inspired by Jekyll, however Jekyll was designed to be run as a service that does not allow arbitrary Ruby code to be run (hence it's use of Liquid and Markdown, as opposed to things like Haml). This suits it's purpose perfectly for GitHub, but imposes unnecessary restrictions for other users.

Additionally Jekyll has no concept of files being associated with Posts, which makes writing plugins to handle things like images on a per-post basis very difficult.

Potion was designed to address these issues.

Why would I use Potion?
-----------------------

* Potion provides support for nearly every major template and markup language including HTML, HAML, Markdown, Liquid, SASS and many more (thanks to Tilt!)
* Potion is extremely extensible: want to make every photo on your site black-and-white without using Photoshop? No problems. And this is only the beginning!


Who should use Potion?
----------------------

* Anyone who is comfortable programming, and wants to build a website or blog.
* Anyone who likes Jekyll, but needs 'more'.

Who should avoid Potion?
------------------------

* People that want a WYSIWYG editor.
* Anyone who just wants a template website.

Installing Potion
=================

Assuming that you already have Ruby and Rubygems installed, installing potion is a snap!

  gem install potion
  
Directory Structure
===================

Much like Jekyll, Potion uses the directory structure of your site to determine the relationships of files to one another. A notable difference is that in Potion each 'Post' is a folder rather than a single file. This allows you to associate files like photos and downloads with a post in a simple fashion.

A typical file structure for a Potion site would look like:

    /
    |- _config.yml
    |- _extensions
    |     |- photo_resizer.rb
    |     |- more_cowbell_helper.rb
    |
    |- _layouts
    |     |- main.haml
    |     |- blog.haml
    |
    |- assets
    |     |- main.js
    |     |- main.sass
    |
    |- blog
    |     |-_posts
    |           |- 2013-04-03-post-1
    |           |     |- post-1.html.haml <- Post
    |           |     |- kittens.jpg 
    |           |
    |           |- 2013-04-05-post-2
    |                 |- post-2.html.haml <- Post
    |                 |- not-a-virus.exe    
    |
    |- index.html.haml <- Page
  
  
Types of content
================

Potion supports 3 distinct types of content: Pages, Posts and Static File.

Pages
-----

A 'Page' is any page on your website that will not be a part of a series. A contact page or about page for instance. For a file to be classified as a Page it must have a YAML header, but must not reside in a path that contains the '_posts' qualifier.

Posts
-----

A 'Post' is any page that will be part of a series. For instance a blog post, or one of the pages in a catalogue. A post can have multiple static files associated with it. For a file to be classified as a Post it must have a YAML header and have a '_posts' folder upstream in it's path.

Static Files
------------

A static file is any file that does not have a YAML header. Static Files are still processed by Potion to allow extensions the opportunity to perform operations like image resizing etc.
  
Customizing Potion
==================

There are two main ways of customizing how Potion functions: Helpers and Extensions.

Helpers are analagous to Rails Helpers, they are methods that you call from a page or post that provide some functionality. Potion ships with a number of built-in helpers, eg:

    = # Find the first photo associated with the current Post that 
    = # has the work 'kitten' in the filename and insert it here.
    
    = photo("kitten") 
  
Writing a helper is simple, just add a Ruby file to the `_extensions` directory in the root of your site:

    # /_extensions/christmas_annoyance_helper.rb
    module Potion::Helpers
      def christmas_annoyance(repeat = 0)
        output = ""
        repeat.times do
          output << "<p>Jingle, Jingle, Jingle bell rock<br />"
          output << "What a bright time<br />"
          output << "Jingle, Jingle, Jingle bell rock<br />"
          output << "It's the right time</p>"
        end
    
        output
      end
    end

Whatever the helper returns will be inserted into the calling layout, page or post at the position the helper was called. Helpers have full access to all the information that Potion gathers about your site. Some useful examples include:

    @metadata               # a hash of the data loaded from the YAML header of the page or post
    @output_path            # the path that the current file will be output to
    @relative_output_path   # the path that the current will be output to relative to the root of the site
    @static_files           # the list of static files associated with a Post, not available for pages
    @site                   # a reference to the Site object that is associated with the page or post
    @layout                 # a reference to the Layout object that is associated with the page or post
    
    @site.config            # a hash of the data loaded from the _config.yml file in the site's root
    @site.metadata          # a hash that extensions and helpers can use to store data they generate
    @site.base_path         # the absolute path of the source site
    @site.destination_path  # the absolute path of the destination for the site
    @site.posts             # an array of all the posts in the site
    @site.pages             # an array of all the pages in the site
    @site.static_files      # an array of all the static files in the site
    @site.layouts           # an array of all the layouts in the site
    @site.extensions        # an array of all the extensions currently loaded for the site
  
For more information on available attributes it's probably best just to refer to the code (there's not much of it, and it's clean!)

Writing an extension gives you the ability to 'filter' each file before it is written to the generated site. This is a good way to resize photos or perform some transformation on all the posts in your site.

An extension is simply a Ruby class that responds to the `process` instance method and takes a single argument. Each extension also needs to register itself after it loads by calling the `Potion::Site.register_extension` method.

For instance if you wanted to apply some 'artsty' filters to all the photos in your website or blog you could write an extension like this:

    #/_extensions/too_cheap_for_instagram.rb
    require 'mini_magick'
    
    class TooCheapForInstagram
      def process(item)
        return unless item.is_a?(Potion::StaticFile)
        extensions = [".jpg", ".jpeg", ".gif", ".png"]    
        return unless extensions.include?(File.extname(item.output_path).downcase)
    
        image = MiniMagick::Image.read(item.content)
        image.sepia_tone("80%")
        image.vignette("10")
        item.content = image.to_blob
      end
    end
    
    Potion::Site.register_extension(TooCheapForInstagram)

Extensions alter the site by writing data back to the posts, pages and static files using their accessor methods. Some of the most useful accessor methods are:

    item.content                # the content of the post, page, or static file
    item.metadata               # a hash of the data loaded from the YAML header of the page or post
    item.output_path            # the path where the item will be written when the site is generated
    item.relative_output_path   # the output path of the item relative to the destination root
  
All of these are getters AND setters. Strange things may happen if you set anything other than the metadata and content though, so beware! To get information on all the getters and setters available it is best to look at the source for the relevant objects (/lib/potion/*.rb).
  
