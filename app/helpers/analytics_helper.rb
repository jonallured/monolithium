module AnalyticsHelper
  def summary_description(analytics_report)
    item_count = analytics_report.matching_items.count.to_fs(:delimited)
    row_count = analytics_report.rows.count.to_fs(:delimited)

    [
      "Summary of",
      pluralize(item_count, "matching item"),
      "grouped by page into",
      pluralize(row_count, "row")
    ].join(" ") + "."
  end
end
