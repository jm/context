require File.dirname(__FILE__) + '/test_helper.rb'

class TestLifecycle < Test::Unit::TestCase
  context "A before block" do
    it "should define a setup method" do
      self.class.before { true }
      assert self.class.method_defined?(:setup)
    end
  end
  
  context "An after block" do
    it "should define a teardown method" do
      self.class.after { true }
      assert self.class.method_defined?(:teardown)
    end
  end
end
