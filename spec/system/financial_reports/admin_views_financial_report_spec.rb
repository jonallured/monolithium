require "rails_helper"

describe "Admin views financial reports" do
  include_context "admin password matches"

  let!(:last_year) { Date.today - 1.year }

  let!(:usb_checking) { FactoryBot.create(:usb_checking) }
  let!(:wf_checking) { FactoryBot.create(:wf_checking) }
  let!(:wf_savings) { FactoryBot.create(:wf_savings) }

  scenario "with no statements for that year" do
    visit "/financial_reports/#{last_year}"

    header_h1 = page.find("header nav h1")
    expect(header_h1.text).to eq last_year.year.to_s

    prev_link, next_link = page.all("header nav a").to_a

    expect(prev_link.text).to eq "prev"
    expect(prev_link["href"]).to end_with((last_year.year - 1).to_s)

    expect(next_link.text).to eq "next"
    expect(next_link["href"]).to end_with((last_year.year + 1).to_s)

    checking_table, savings_table = page.all("table").to_a

    within checking_table do
      checking_trs = checking_table.all("tr").to_a

      month_tr = checking_trs[0]
      starting_tr = checking_trs[1]
      income_tr = checking_trs[2]
      expenses_tr = checking_trs[3]
      ending_tr = checking_trs[4]
      net_tr = checking_trs[5]

      expect(month_tr.all("th").map(&:text)).to eq %w[
        Month Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
      ]

      expect(starting_tr.all("td").map(&:text)).to eq %w[
        Starting - - - - - - - - - - - -
      ]

      expect(income_tr.all("td").map(&:text)).to eq %w[
        Income - - - - - - - - - - - -
      ]

      expect(expenses_tr.all("td").map(&:text)).to eq %w[
        Expenses - - - - - - - - - - - -
      ]

      expect(ending_tr.all("td").map(&:text)).to eq %w[
        Ending - - - - - - - - - - - -
      ]

      expect(net_tr.all("td").map(&:text)).to eq %w[
        Net - - - - - - - - - - - -
      ]
    end

    within savings_table do
      month_tr, starting_tr, ending_tr, net_tr = savings_table.all("tr").to_a

      expect(month_tr.all("th").map(&:text)).to eq %w[
        Month Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
      ]

      expect(starting_tr.all("td").map(&:text)).to eq %w[
        Starting - - - - - - - - - - - -
      ]

      expect(ending_tr.all("td").map(&:text)).to eq %w[
        Ending - - - - - - - - - - - -
      ]

      expect(net_tr.all("td").map(&:text)).to eq %w[
        Net - - - - - - - - - - - -
      ]
    end
  end

  scenario "with one statement in the middle of that year" do
    FactoryBot.create(
      :financial_statement,
      financial_account: wf_checking,
      period_start_on: Date.parse("#{last_year.year}-05-01"),
      starting_amount_cents: 1_034_89,
      ending_amount_cents: 99_00
    )

    visit "/financial_reports/#{last_year}"

    checking_table = page.all("table").to_a.first
    checking_trs = checking_table.all("tr").to_a

    starting_tr = checking_trs[1]
    income_tr = checking_trs[2]
    expenses_tr = checking_trs[3]
    ending_tr = checking_trs[4]
    net_tr = checking_trs[5]

    may_starting_td = starting_tr.all("td").to_a[5]
    expect(may_starting_td.text).to eq "$1,034.89"

    may_income_td = income_tr.all("td").to_a[5]
    expect(may_income_td.text).to eq "-"

    may_expenses_td = expenses_tr.all("td").to_a[5]
    expect(may_expenses_td.text).to eq "-"

    may_ending_td = ending_tr.all("td").to_a[5]
    expect(may_ending_td.text).to eq "$99.00"

    may_net_td = net_tr.all("td").to_a[5]
    expect(may_net_td.text).to eq "($935.89)"
  end

  scenario "with statements for every month of that year" do
    FinancialReport.months_for_year(last_year.year).each do |date|
      FactoryBot.create(
        :financial_statement,
        financial_account: wf_checking,
        period_start_on: date,
        starting_amount_cents: 1_034_89,
        ending_amount_cents: 99_00
      )

      FactoryBot.create(
        :financial_statement,
        financial_account: wf_savings,
        period_start_on: date,
        starting_amount_cents: 99_00,
        ending_amount_cents: 1_034_89
      )
    end

    visit "/financial_reports/#{last_year}"

    checking_table, savings_table = page.all("table").to_a

    within checking_table do
      checking_trs = checking_table.all("tr").to_a

      starting_tr = checking_trs[1]
      ending_tr = checking_trs[4]
      net_tr = checking_trs[5]

      _starting_label, *starting_tds = starting_tr.all("td").to_a
      expect(starting_tds.count).to eq 12
      expect(starting_tds.map(&:text).uniq).to eq ["$1,034.89"]

      _ending_label, *ending_tds = ending_tr.all("td").to_a
      expect(ending_tds.count).to eq 12
      expect(ending_tds.map(&:text).uniq).to eq ["$99.00"]

      _net_label, *net_tds = net_tr.all("td").to_a
      expect(net_tds.count).to eq 12
      expect(net_tds.map(&:text).uniq).to eq ["($935.89)"]
    end

    within savings_table do
      _month_tr, starting_tr, ending_tr, net_tr = savings_table.all("tr").to_a

      _starting_label, *starting_tds = starting_tr.all("td").to_a
      expect(starting_tds.count).to eq 12
      expect(starting_tds.map(&:text).uniq).to eq ["$99.00"]

      _ending_label, *ending_tds = ending_tr.all("td").to_a
      expect(ending_tds.count).to eq 12
      expect(ending_tds.map(&:text).uniq).to eq ["$1,034.89"]

      _net_label, *net_tds = net_tr.all("td").to_a
      expect(net_tds.count).to eq 12
      expect(net_tds.map(&:text).uniq).to eq ["$935.89"]
    end
  end

  scenario "with two statements on two accounts for the same period" do
    FactoryBot.create(
      :financial_statement,
      financial_account: usb_checking,
      period_start_on: Date.parse("#{last_year.year}-05-01"),
      starting_amount_cents: 100_00,
      ending_amount_cents: 50_00
    )

    FactoryBot.create(
      :financial_statement,
      financial_account: wf_checking,
      period_start_on: Date.parse("#{last_year.year}-05-01"),
      starting_amount_cents: 70_00,
      ending_amount_cents: 20_00
    )

    visit "/financial_reports/#{last_year}"

    checking_table = page.all("table").to_a.first
    checking_trs = checking_table.all("tr").to_a

    starting_tr = checking_trs[1]
    ending_tr = checking_trs[4]
    net_tr = checking_trs[5]

    may_starting_td = starting_tr.all("td").to_a[5]
    expect(may_starting_td.text).to eq "$170.00"

    may_ending_td = ending_tr.all("td").to_a[5]
    expect(may_ending_td.text).to eq "$70.00"

    may_net_td = net_tr.all("td").to_a[5]
    expect(may_net_td.text).to eq "($100.00)"
  end

  scenario "with one statement in the middle of that year" do
    FactoryBot.create(
      :financial_statement,
      financial_account: wf_checking,
      period_start_on: Date.parse("#{last_year.year}-05-01"),
      starting_amount_cents: 1_034_89,
      ending_amount_cents: 99_00
    )

    FactoryBot.create(
      :financial_transaction,
      financial_account: wf_checking,
      posted_on: Date.parse("#{last_year.year}-05-01"),
      amount_cents: 900_00
    )

    FactoryBot.create(
      :financial_transaction,
      financial_account: wf_checking,
      posted_on: Date.parse("#{last_year.year}-05-01"),
      amount_cents: -1_835_89
    )

    visit "/financial_reports/#{last_year}"

    checking_table = page.all("table").to_a.first
    checking_trs = checking_table.all("tr").to_a

    starting_tr = checking_trs[1]
    income_tr = checking_trs[2]
    expenses_tr = checking_trs[3]
    ending_tr = checking_trs[4]
    net_tr = checking_trs[5]

    may_starting_td = starting_tr.all("td").to_a[5]
    expect(may_starting_td.text).to eq "$1,034.89"

    may_income_td = income_tr.all("td").to_a[5]
    expect(may_income_td.text).to eq "$900.00"

    may_expenses_td = expenses_tr.all("td").to_a[5]
    expect(may_expenses_td.text).to eq "($1,835.89)"

    may_ending_td = ending_tr.all("td").to_a[5]
    expect(may_ending_td.text).to eq "$99.00"

    may_net_td = net_tr.all("td").to_a[5]
    expect(may_net_td.text).to eq "($935.89)"
  end
end
