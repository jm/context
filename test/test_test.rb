require File.dirname(__FILE__) + '/test_helper.rb'

class TestTest < Test::Unit::TestCase
  def test_test_aliases
    [:test, :it, :should, :tests].each do |method_alias|
      assert self.class.respond_to?(method_alias)
    end
  end
  
  context "A test block" do
    it "should create a test_xxx method" do
      self.class.test("should create a test method") { true }
      
      assert self.respond_to?(:test_a_test_block_should_create_a_test_method)
    end
  end
end
