class DrainHooksJob < ApplicationJob
  def perform
    Hook::Cleaner.drain
  end
end
