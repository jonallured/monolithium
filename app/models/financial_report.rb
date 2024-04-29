class FinancialReport
  def self.months_for_year(year)
    start_on = Date.parse("#{year}-01-01")
    end_on = Date.parse("#{year}-12-01")
    (start_on..end_on).uniq(&:month)
  end

  attr_reader :year

  def initialize(year = Time.now.year)
    @year = year
  end

  def prev_year
    @year - 1
  end

  def next_year
    @year + 1
  end

  def category_data
    {
      checking: checking_data,
      savings: savings_data
    }
  end

  def checking_data
    accounts = FinancialAccount.checking
    AccountData.new(accounts, @year)
  end

  def savings_data
    accounts = FinancialAccount.savings
    AccountData.new(accounts, @year)
  end

  class AccountData
    def initialize(accounts, year)
      @accounts = accounts
      @year = year
      grouped_statements
    end

    def starting_amounts
      grouped_statements.map do |statements|
        amounts = statements.map(&:starting_amount_cents).compact
        next if amounts.empty?

        amounts.sum
      end
    end

    def income_amounts
      grouped_transactions.map do |transactions|
        amounts = transactions.map do |transaction|
          next unless transaction.amount_cents&.positive?

          transaction.amount_cents
        end.compact
        next if amounts.empty?

        amounts.sum
      end
    end

    def expenses_amounts
      grouped_transactions.map do |transactions|
        amounts = transactions.map do |transaction|
          next unless transaction.amount_cents&.negative?

          transaction.amount_cents
        end.compact
        next if amounts.empty?

        amounts.sum
      end
    end

    def ending_amounts
      grouped_statements.map do |statements|
        amounts = statements.map(&:ending_amount_cents).compact
        next if amounts.empty?

        amounts.sum
      end
    end

    def net_amounts
      grouped_statements.map do |statements|
        amounts = statements.map(&:net_amount_cents).compact
        next if amounts.empty?

        amounts.sum
      end
    end

    private

    def compute_grouped_statements
      account_statements = @accounts.map { |account| account.financial_statements.for_year(@year) }.flatten
      FinancialReport.months_for_year(@year).map do |date|
        statements_for_period = account_statements.select { |statement| statement.period_start_on == date }
        statements_for_period << NullStatement.instance if statements_for_period.empty?
        statements_for_period
      end
    end

    def grouped_statements
      @grouped_statements ||= compute_grouped_statements
    end

    def compute_grouped_transactions
      account_transactions = @accounts.map { |account| account.financial_transactions.for_year(@year) }.flatten
      FinancialReport.months_for_year(@year).map do |date|
        transactions_for_period = account_transactions.select { |transaction| transaction.posted_on.month == date.month }
        transactions_for_period << NullTransaction.instance if transactions_for_period.empty?
        transactions_for_period
      end
    end

    def grouped_transactions
      @grouped_transactions ||= compute_grouped_transactions
    end
  end
end
