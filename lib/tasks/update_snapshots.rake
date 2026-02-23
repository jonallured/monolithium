desc "Run test, update snapshots, run test again"
task :update_snapshots do
  test_command = "bundle exec rspec spec/generator/crud/pages_generator_spec.rb"
  system(test_command)
  update_command = "cp tmp/generators/crud_pages/app/views/dashboard/show.html.haml spec/fixtures/generators/crud_pages/app/views/dashboard/show.html.haml && cp tmp/generators/crud_pages/config/routes.rb spec/fixtures/generators/crud_pages/config/routes.rb"
  system(update_command)
  system(test_command)
end
