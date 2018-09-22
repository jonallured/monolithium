module Api
  module V1
    class PtoReportsController < Api::V1Controller
      expose(:pto_reports) { PtoReport.all }
    end
  end
end
