class String
  def to_method_name
    self.downcase.gsub(/\s+/,'_')
  end
end