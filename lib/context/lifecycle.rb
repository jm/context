class Test::Unit::TestCase
  class << self
    attr_accessor :before_each_callbacks, :before_all_callbacks, :after_each_callbacks, :after_all_callbacks

    # Add logic to run before the tests (i.e., a +setup+ method)
    #
    #     before do
    #       @user = User.first
    #     end
    # 
    def before(period = :each, &block)
      send("before_#{period}_callbacks") << block
    end
    
    # Add logic to run after the tests (i.e., a +teardown+ method)
    #
    #     after do
    #       User.delete_all
    #     end
    #
    def after(period = :each, &block)
      send("after_#{period}_callbacks") << block
    end
  end

  self.before_all_callbacks  = []
  self.before_each_callbacks = []
  self.after_each_callbacks  = []
  self.after_all_callbacks   = []

  def self.inherited(child)
    super
    child.before_all_callbacks  = before_all_callbacks.dup
    child.before_each_callbacks = before_each_callbacks.dup
    child.after_each_callbacks  = after_each_callbacks.dup
    child.after_all_callbacks   = after_all_callbacks.dup

    child.class_eval do
      def setup
        self.class.before_each_callbacks.each { |c| instance_eval(&c) }
      end

      def teardown
        self.class.after_each_callbacks.each { |c| instance_eval(&c) }
      end
    end
  end

  def run_all_callbacks(period = :before)
    previous_ivars = instance_variables
    self.class.send("#{period}_all_callbacks").each { |c| instance_eval(&c) }
    (instance_variables - previous_ivars).inject({}) do |hash, ivar|
      hash.update ivar => instance_variable_get(ivar)
    end
  end

  def set_values_from_callbacks(values)
    values.each do |name, value|
      instance_variable_set name, value
    end
  end
end