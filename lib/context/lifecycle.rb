class Test::Unit::TestCase
  class << self
    attr_accessor :before_each_callbacks
    attr_accessor :after_each_callbacks

    # Add logic to run before the tests (i.e., a +setup+ method)
    #
    #     before do
    #       @user = User.first
    #     end
    # 
    def before(&block)
      before_each_callbacks << block
    end
    
    # Add logic to run after the tests (i.e., a +teardown+ method)
    #
    #     after do
    #       User.delete_all
    #     end
    #
    def after(&block)
      after_each_callbacks << block
    end
  end

  self.before_each_callbacks = []
  self.after_each_callbacks  = []

  def self.inherited(child)
    super
    child.before_each_callbacks = before_each_callbacks.dup
    child.after_each_callbacks  = after_each_callbacks.dup

    child.class_eval do
      def setup
        self.class.before_each_callbacks.each { |c| instance_eval(&c) }
      end

      def teardown
        self.class.after_each_callbacks.each { |c| instance_eval(&c) }
      end
    end
  end
end