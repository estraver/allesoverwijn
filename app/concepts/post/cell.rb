# require 'uber/delegates'
# require 'attachment/post_attachment'
# require 'category/most_used_category_collection'
# require 'post/archive/archive_collection'
#
# class Post::NavigationLinkCell < NavigationLinkCell::Concept
#   def show
#     render
#   end
#
#   class Author < NavigationLinkCell::Concept
#     inherit_views Post::Widget
#     include NavigationLinkCell::ContentCell
#
#     def show
#       render :author
#     end
#
#   end
#
#   class Preview < NavigationLinkCell::Concept
#     inherit_views Post::Widget
#
#     def show
#       render :preview
#     end
#
#     private
#
#     def click_trap
#       tag :div, style: 'position: absolute; width: 100%; height: 100%; z-index: 1000; background: white none repeat scroll 0% 0%; left: 0; top: 0; cursor: default; opacity: 0.01;'
#     end
#
#     def preview_text(text)
#       content_tag :div, class: 'preview-watermark' do
#         text
#       end
#     end
#   end
#
#   class Picture < NavigationLinkCell::Concept
#     extend Uber::Delegates
#     include NavigationLinkCell::ImageCell
#
#     delegates :model, :post
#     delegates :post, :picture_meta_data
#
#     attachment :picture, PostAttachment
#
#   end
#
#   class Sidebar < NavigationLinkCell::Concept
#     include NavigationLinkCell::ListCell
#     inherit_views Post::Widget
#
#     self.classes = %w(sidebar)
#
#     def show
#       render :sidebar
#     end
#
#     private
#
#     def categories
#       MostUsedCategoryCollection.new(Category, current_user: model.current_user).()
#     end
#
#     def archives
#       ArchiveCollection.new(Property).()
#     end
#   end
# end
