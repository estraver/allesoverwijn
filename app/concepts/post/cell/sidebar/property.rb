 module Post::Cell
   module Sidebar
     class Property  < Trailblazer::Cell
       include SimpleForm::ActionViewExtensions::FormHelper

       layout :widget_edit_layout

       def title
         _('post.sidebar.properties.title')
       end

       def icon
         'fa-cogs'
       end

     end
   end
 end