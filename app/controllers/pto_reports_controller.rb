class PtoReportsController < ApiController
  expose(:pto_reports) { PtoReport.all }
end
