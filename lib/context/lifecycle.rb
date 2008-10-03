class Test::Unit::TestCase
  # TODO: Chained lifecycle methods
  class << self
    def before(&block)
      define_method(:setup, &block)
    end
    
    def after(&block)
      define_method(:teardown, &block)
    end
  end
end