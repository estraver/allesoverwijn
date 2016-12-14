# # require 'abstract_post/abstract_post'
#
# class Blog::NavigationLinkCell < NavigationLinkCell::Concept
#   include NavigationLinkCell::ContentCell
#
#   def show
#     render
#   end
#
#   def preview?
#     @options[:preview]
#   end
#
#   def abstract?
#     @options[:abstract]
#   end
#
#   private
#
#   # TODO: realize comment count
#   def comments_count
#     0
#   end
#
#   # TODO: realize count view
#   def views_count
#     0
#   end
#
#   class List < NavigationLinkCell::Concept
#     inherit_views Blog::NavigationLinkCell
#
#     property :published
#     # property :current_user
#
#     def show
#       concept('blog/cell', collection: model.published, operation: model, abstract: true)
#       # render :list
#     end
#   end
#
#   class Show < NavigationLinkCell::Concept
#     # inherit_views Blog::Widget
#
#     def show
#       concept('blog/cell', model, operation: @options[:operation], preview: @options[:preview], abstract: @options[:abstract])
#     end
#   end
#
# end
