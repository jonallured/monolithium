# gem install circleci

require "circleci"

CircleCi.configure do |config|
  config.token = File.read("circleci-unfollow/token.txt")
end

projects = CircleCi::Projects.new.get.body

artsy_projects = projects.select do |project|
  project["username"] == "artsy"
end

puts "#{artsy_projects.count} artsy projects found"

artsy_projects.each do |project|
  username = project["username"]
  reponame = project["reponame"]
  puts "unfollowing #{username}/#{reponame}"
  CircleCi::Project.new(username, reponame).unfollow
end
