module AnalyticsHelper
  def detail_description(analytics_report)
    item_count = analytics_report.matching_items.count.to_fs(:delimited)
    metric = analytics_report.metric_name
    current_page = analytics_report.paginated_items.current_page
    total_pages = analytics_report.paginated_items.total_pages
    page_info = "(page #{current_page} of #{total_pages})"

    [
      "Detail of",
      pluralize(item_count, "matching item"),
      "with",
      metric,
      page_info
    ].join(" ") + "."
  end

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
