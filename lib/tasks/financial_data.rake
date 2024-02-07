require "csv"

class StatementChecker
  class LastStatementMismatch < StandardError; end

  class NextStatementMismatch < StandardError; end

  class DiffAndNetMismatch < StandardError; end

  def initialize(statements, account_name)
    @statements = statements
    @account_name = account_name
  end

  def check
    sorted_statements.each_with_index do |statement, index|
      last_statement_index = index - 1
      next_statement_index = index + 1

      last_statement = last_statement_index > 0 && sorted_statements[last_statement_index]
      next_statement = next_statement_index < sorted_statements.count && sorted_statements[index + 1]

      begin
        verify_amounts(last_statement, statement, next_statement)
      rescue DiffAndNetMismatch => e
        puts statement
        raise e
      rescue => e
        puts last_statement, statement, next_statement
        raise e
      end
    end
  end

  private

  def sorted_statements
    @sorted_statements ||= @statements.sort_by { |statement| statement[:period_start_on] }
  end

  def verify_amounts(last_statement, statement, next_statement)
    if last_statement
      raise LastStatementMismatch unless statement[:starting_amount_cents] == last_statement[:ending_amount_cents]
    end

    if next_statement
      raise NextStatementMismatch unless statement[:ending_amount_cents] == next_statement[:starting_amount_cents]
    end

    slug = statement[:period_start_on].to_s[0, 7]
    transactions_path = Dir.home + "/Desktop/financial-data/#{@account_name}/#{slug}-transactions.csv"
    if File.exist?(transactions_path)
      transaction_net = CSV.open(transactions_path, headers: true).map { |row| (row["Amount"].to_r * 100).to_i }.sum
      amount_diff = statement[:ending_amount_cents] - statement[:starting_amount_cents]

      drift = amount_diff - transaction_net
      raise DiffAndNetMismatch unless drift == 0
    end
  end
end

namespace :financial_data do
  desc "Verify Statements"
  task :verify_statements, [:statement_path] do |_task, args|
    statement_path = Dir.home + args[:statement_path]
    data = File.read(statement_path)
    table = CSV.parse(data, headers: true)

    statements = table.map do |row|
      {
        period_start_on: Date.parse(row["period_start_on"]),
        starting_amount_cents: row["starting_amount_cents"].to_i,
        ending_amount_cents: row["ending_amount_cents"].to_i
      }
    end

    account_name = statement_path.match(/financial-data\/(.*)\/statements\.csv/).captures.first

    checker = StatementChecker.new(statements, account_name)
    checker.check
  end

  desc "Split Transaction Data"
  task :split_transactions, [:transactions_path] do |_task, args|
    transactions_path = Dir.home + args[:transactions_path]
    data = File.read(transactions_path)
    table = CSV.parse(data, headers: true)

    usb_transactions, wf_transactions = table.partition do |row|
      row["Memo"]&.starts_with?("Download from usbank.com")
    end

    usb_rows = usb_transactions.map do |row|
      memo = row["Name"]

      if memo == "CHECK"
        memo = memo + " " + row["Transaction"]
      end

      [row["Date"], row["Amount"], memo]
    end

    wf_rows = wf_transactions.map do |row|
      memo = row["Name"] || row["Memo"]

      [row["Date"], row["Amount"], memo]
    end

    header_row = %w[Date Amount Memo]

    usb_transaction_data = usb_rows.unshift(header_row).map(&:to_csv).join
    wf_transaction_data = wf_rows.unshift(header_row).map(&:to_csv).join

    usb_transactions_path = transactions_path.gsub("combined-data", "usb-checking")
    wf_transactions_path = transactions_path.gsub("combined-data", "wf-checking")

    File.write(usb_transactions_path, usb_transaction_data)
    File.write(wf_transactions_path, wf_transaction_data)
  end

  desc "Import Statement Data"
  task import_statements: :environment do
    [
      [FinancialAccount.usb_checking, "usb-checking"],
      [FinancialAccount.wf_checking, "wf-checking"],
      [FinancialAccount.wf_savings, "wf-savings"]
    ].each do |(account, folder)|
      key = "financial-data/#{folder}/statements.csv"
      data = S3Api.read(key)
      table = CSV.parse(data, headers: true)
      table.each do |row|
        attrs = {
          ending_amount_cents: row["ending_amount_cents"],
          period_start_on: row["period_start_on"],
          starting_amount_cents: row["starting_amount_cents"]
        }
        account.financial_statements.create(attrs)
      end
    end
  end

  desc "Import Transaction Data"
  task import_transactions: :environment do
    [
      [FinancialAccount.usb_checking, "usb-checking"],
      [FinancialAccount.wf_checking, "wf-checking"]
    ].each do |(account, folder)|
      account.financial_statements.each do |statement|
        slug = statement.period_start_on.to_s[0, 7]
        key = "financial-data/#{folder}/#{slug}-transactions.csv"
        data = S3Api.read(key)
        table = CSV.parse(data, headers: true)
        table.each do |row|
          attrs = {
            amount_cents: (row["Amount"].to_r * 100).to_i,
            description: row["Memo"],
            posted_on: Date.strptime(row["Date"], "%m/%d/%Y")
          }
          account.financial_transactions.create(attrs)
        end
      end
    end
  end
end
