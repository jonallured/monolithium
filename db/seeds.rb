financial_accounts = [
  {id: 1, name: "US Bank Checking"},
  {id: 2, name: "Wells Fargo Checking"},
  {id: 3, name: "Wells Fargo Savings"}
]

financial_accounts.each do |attrs|
  FinancialAccount.create(attrs) unless FinancialAccount.exists?(attrs)
end

services = [
  {id: 1, name: "Circle CI", parser: "CircleciParser"},
  {id: 2, name: "GitHub", parser: "GithubParser"},
  {id: 3, name: "Heroku", parser: "HerokuParser"}
]

services.each do |attrs|
  WebhookSender.create(attrs) unless WebhookSender.exists?(attrs)
end
