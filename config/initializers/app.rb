require_dependency 'navigation_link'
require_dependency 'carousel_slide'
require_dependency 'abstract_post/property_type'

NavigationLink.setup!
CarouselSlide.setup!
AbstractPost::PropertyType.setup!

require 'tyrant/railtie'