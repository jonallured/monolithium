class ParseRawHookJob < ApplicationJob
  def perform(raw_hook_id)
    raw_hook = RawHook.find(raw_hook_id)
    return unless raw_hook

    klasses = [
      CircleciParser,
      GithubParser,
      HerokuParser
    ]

    klasses.each { |klass| klass.check_and_maybe_parse(raw_hook) }
  end
end
