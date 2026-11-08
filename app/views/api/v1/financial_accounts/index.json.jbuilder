json.array!(financial_accounts) do |financial_account|
  json.partial!("api/v1/financial_accounts/financial_account", financial_account: financial_account)
end
