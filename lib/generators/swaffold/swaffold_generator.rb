require 'rails/generators/rails/scaffold/scaffold_generator'
class SwaffoldGenerator < Rails::Generators::ScaffoldGenerator
  def main
    insert_into_file "app/views/layouts/application.html.erb", "<li class=\"nav-item\"><%= link_to #{class_name.singularize}.model_name.human, #{plural_table_name}_path, class: 'nav-link' %></li>\n", after: "<ul class=\"navbar-nav mr-auto\">\n"
  end
#  hook_for :scaffold

end
