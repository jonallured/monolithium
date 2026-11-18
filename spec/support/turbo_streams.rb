require "turbo/system_test_helper"

module TurboStreamsHelper
  include Turbo::SystemTestHelper

  def visit(...)
    super.tap { connect_turbo_cable_stream_sources }
  end
end
