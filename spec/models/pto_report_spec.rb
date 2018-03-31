require 'rails_helper'

describe PtoReport do
  describe '.all' do
    context 'with no work days' do
      it 'returns an empty array' do
        expect(PtoReport.all).to eq []
      end
    end

    context 'with no pto minutes' do
      it 'returns an empty array' do
        FactoryBot.create :work_day, date: '2017-01-02', pto_minutes: 0
        expect(PtoReport.all).to eq []
      end
    end

    context 'with a couple days of pto' do
      it 'returns a report with those pto minutes' do
        FactoryBot.create :work_day, date: '2017-01-02', pto_minutes: 480

        pto_reports = PtoReport.all

        expect(pto_reports.count).to eq 1

        pto_report = pto_reports.first
        expect(pto_report.year).to eq 2017
        expect(pto_report.ytd_minutes).to eq 480
        expect(pto_report.all_minutes).to eq 480
        expect(pto_report.pto_days.count).to eq 1

        pto_day = pto_report.pto_days.first
        expect(pto_day.date).to eq Date.parse('2017-01-02')
        expect(pto_day.minutes).to eq 480
      end
    end

    context 'with a few years worth of pto' do
      it 'returns a few reports with those pto minutes' do
        today = Time.zone.today
        this_year = today.beginning_of_year
        last_year = today.last_year.beginning_of_year
        next_year = today.next_year.beginning_of_year

        FactoryBot.create :work_day, date: this_year, pto_minutes: 480
        FactoryBot.create :work_day, date: next_year, pto_minutes: 240
        FactoryBot.create :work_day, date: last_year, pto_minutes: 360

        pto_reports = PtoReport.all

        expect(pto_reports.count).to eq 3

        first_pto_report = pto_reports.first
        expect(first_pto_report.ytd_minutes).to eq 360
        expect(first_pto_report.all_minutes).to eq 360

        last_pto_report = pto_reports.last
        expect(last_pto_report.ytd_minutes).to eq 0
        expect(last_pto_report.all_minutes).to eq 240
      end
    end
  end
end
