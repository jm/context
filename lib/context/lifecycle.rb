class Test::Unit::TestCase
  # TODO: Chained lifecycle methods
  class << self
    # Add logic to run before the tests (i.e., a +setup+ method)
    #
    #     before do
    #       @user = User.first
    #     end
    # 
    def before(&block)
      define_method(:setup, &block)
    end
    
    # Add logic to run after the tests (i.e., a +teardown+ method)
    #
    #     after do
    #       User.delete_all
    #     end
    #
    def after(&block)
      define_method(:teardown, &block)
    end
  end
end