require "rails_helper"
require_relative "../../../lib/generators/crud/pages/pages_generator"

describe Crud::PagesGenerator, type: :generator do
  it "generates all the things" do
    FileUtils.rm_rf("tmp/generators")
    FileUtils.mkdir_p("tmp/generators/crud_pages/config")
    FileUtils.cp("config/routes.rb", "tmp/generators/crud_pages/config/routes.rb")
    FileUtils.mkdir_p("tmp/generators/crud_pages/app/views/dashboard")
    FileUtils.cp("app/views/dashboard/show.html.haml", "tmp/generators/crud_pages/app/views/dashboard/show.html.haml")

    args = ["Thing"]
    options = {}
    config = {}
    generator = Crud::PagesGenerator.new(args, options, config)
    generator.destination_root = "tmp/generators/crud_pages"

    expected_output = File.read("spec/fixtures/generators/crud_pages_stdout.txt")

    expect do
      generator.invoke_all
    end.to output(expected_output).to_stdout

    actual_paths = Dir.glob("tmp/generators/crud_pages/**/*").select(&File.method(:file?))
    expected_paths = Dir.glob("spec/fixtures/generators/crud_pages/**/*").select(&File.method(:file?))

    actual_paths.zip(expected_paths).each do |(actual_path, expected_path)|
      actual_filename = actual_path.gsub("tmp/generators", "")
      expected_filename = expected_path.gsub("spec/fixtures/generators", "")
      expect(actual_filename).to eq expected_filename
      expect(FileUtils.compare_file(actual_path, expected_path)).to eq true
    end
  end
end
