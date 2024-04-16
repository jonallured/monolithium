financial_accounts = [
  {id: 1, name: "US Bank Checking", category: "checking"},
  {id: 2, name: "Wells Fargo Checking", category: "checking"},
  {id: 3, name: "Wells Fargo Savings", category: "savings"}
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
