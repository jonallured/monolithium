services = [
  {id: 1, name: "Circle CI", parser: "CircleciParser"},
  {id: 2, name: "GitHub", parser: "GithubParser"},
  {id: 3, name: "Heroku", parser: "HerokuParser"}
]

services.each do |attrs|
  WebhookSender.create(attrs) unless WebhookSender.exists?(attrs)
end
