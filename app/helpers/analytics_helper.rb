module AnalyticsHelper
  def summary_description(analytics_report)
    item_count = analytics_report.matching_items.count.to_fs(:delimited)
    grouping = analytics_report.metric_name
    row_count = analytics_report.rows.count.to_fs(:delimited)

    [
      "Summary of",
      pluralize(item_count, "matching item"),
      "grouped by",
      grouping,
      "into",
      pluralize(row_count, "row")
    ].join(" ") + "."
  end
end
