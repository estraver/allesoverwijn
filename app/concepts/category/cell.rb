# class Category::NavigationLinkCell < NavigationLinkCell::Concept
#   class Link < NavigationLinkCell::Concept
#     include NavigationLinkCell::ListCell
#     inherit_views Category::NavigationLinkCell
#
#     property :child_categories
#     property :name
#
#     self.classes = %w(category-links)
#
#     def show
#       render :link
#     end
#
#     private
#
#     # TODO: Change to route
#     def url(link)
#       '#'
#     end
#
#   end
# end