class Hook::Cleaner
  def self.drain
    Hook.delete_all
    RawHook.delete_all
  end
end
