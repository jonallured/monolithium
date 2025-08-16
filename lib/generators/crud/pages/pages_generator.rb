class Crud::PagesGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path("templates", __dir__)

  def create_controller
    controller_folder = "app/controllers/crud"
    template "controller.erb", "#{controller_folder}/#{plural_name}_controller.rb"
  end

  def add_routes
    route "resources :#{plural_name}", namespace: :crud
  end

  def create_views
    view_folder = "app/views/crud/#{plural_name}"

    template "views/_form.erb", "#{view_folder}/_form.html.haml"
    template "views/edit.erb", "#{view_folder}/edit.html.haml"
    template "views/index.erb", "#{view_folder}/index.html.haml"
    template "views/new.erb", "#{view_folder}/new.html.haml"
    template "views/show.erb", "#{view_folder}/show.html.haml"
  end

  def create_specs
    spec_folder = "spec/system/crud/#{plural_name}"

    template "specs/admin_creates.erb", "#{spec_folder}/admin_creates_#{singular_name}_spec.rb"
    template "specs/admin_edits.erb", "#{spec_folder}/admin_edits_#{singular_name}_spec.rb"
    template "specs/admin_views_list.erb", "#{spec_folder}/admin_views_#{plural_name}_spec.rb"
    template "specs/admin_views_one.erb", "#{spec_folder}/admin_views_#{singular_name}_spec.rb"
  end

  def update_dashboard
    dashboard_view = "app/views/dashboard/show.html.haml"
    crud_link = "%p= link_to \"#{human_name.pluralize.titleize}\", crud_#{plural_name}_path\n"
    crud_heading = "%h2 CRUD Pages\n\n"

    insert_into_file dashboard_view, crud_link, after: crud_heading
  end
end
