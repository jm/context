class String
  # Replaces spaces and tabs with _ so we can use the string as a method name
  def to_method_name
    self.downcase.gsub(/\s+/,'_')
  end
end