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

  def checking_data
    AccountData.new(FinancialAccount.wf_checking, @year)
  end

  def savings_data
    AccountData.new(FinancialAccount.wf_savings, @year)
  end

  class AccountData
    def initialize(account, year)
      @account = account
      @year = year
    end

    def starting_amounts
      statements.map(&:starting_amount_cents)
    end

    def ending_amounts
      statements.map(&:ending_amount_cents)
    end

    def net_amounts
      statements.map(&:net_amount_cents)
    end

    private

    def compute_statements
      account_statements = @account.financial_statements.for_year(@year)
      FinancialReport.months_for_year(@year).map do |date|
        statement_for_period = account_statements.find { |statement| statement.period_start_on == date }
        statement_for_period || NullStatement.instance
      end
    end

    def statements
      @statements ||= compute_statements
    end
  end
end
