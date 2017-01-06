require 'navigation_link'
require 'carousel_slide'
require 'abstract_post/property_type'
require 'tabs/tabs'

NavigationLink.setup!
CarouselSlide.setup!
AbstractPost::PropertyType.setup!
Tabs::Tabs.setup!

require 'tyrant/railtie'