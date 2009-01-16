require File.dirname(__FILE__) + '/test_helper.rb'

class TestLifecycle < Test::Unit::TestCase
  before do
    @inherited_before_each_var = 1
  end

  before do
    @inherited_before_each_var = 2
    @inherited_before_each_var_2 = 1
  end

  after do
    @inherited_after_each_var = 1
  end

  before :all do
    @inherited_before_all_var = 1
  end

  after :all do
    @inherited_after_all_var = 1
  end

  sample_test = context "lifecycle" do
    attr_reader :inherited_before_each_var, :inherited_before_each_var_2, :inherited_after_each_var, 
      :after_each_var, :inherited_before_all_var, :inherited_after_all_var, :before_all_var, :after_all_var, 
      :superclass_before_each_var, :superclass_after_each_var, :superclass_before_all_var, :superclass_after_all_var, :one, :two

    before do
      @inherited_before_each_var = 3
    end

    after do
      @after_each_var = 1
    end

    before :all do
      @before_all_var = 1
    end

    after :all do
      @after_all_var = 1
    end

    test "foo" do
    end
  end

  before do
    @superclass_before_each_var = 1
  end

  after do
    @superclass_after_each_var = 1
  end

  before :all do
    @superclass_before_all_var = 1
  end

  after :all do
    @superclass_after_all_var = 1
  end

  context "With before/after :each blocks" do
    before do
      @result = Test::Unit::TestResult.new
      @test = sample_test.new("test: lifecycle foo")
      @test.run(@result) { |inherited_after_each_var, v| }
    end

    it "it runs superclass before callbacks in order" do
      assert_equal 1, @test.superclass_before_each_var
    end

    it "it runs inherited before callbacks in order" do
      assert_equal 3, @test.inherited_before_each_var
    end

    it "it runs before callbacks in order" do
      assert_equal 1, @test.inherited_before_each_var_2
    end

    it "it runs superclass after callbacks" do
      assert_equal 1, @test.superclass_after_each_var
    end

    it "it runs inherited after callbacks" do
      assert_equal 1, @test.inherited_after_each_var
    end

    it "it runs after callbacks" do
      assert_equal 1, @test.after_each_var
    end
  end

  context "With before/after :all blocks" do
    before do
      @result = Test::Unit::TestResult.new
      @suite  = sample_test.suite
      @suite.run(@result) { |inherited_after_each_var, v| }
      @test   = @suite.tests.first
    end

    it "it runs superclass before callbacks in order" do
      assert_equal 1, @test.superclass_before_all_var
    end

    it "it runs inherited before callbacks in order" do
      assert_equal 1, @test.inherited_before_all_var
    end

    it "it runs before callbacks in order" do
      assert_equal 1, @test.before_all_var
    end

    it "it runs superclass after callbacks" do
      assert_equal 1, @test.superclass_after_all_var
    end

    it "it runs inherited after callbacks" do
      assert_equal 1, @test.inherited_after_all_var
    end

    it "it runs after callbacks" do
      assert_equal 1, @test.after_all_var
    end
  end
  
  # Test that we aren't stomping on defined seutp method
  context "With setup/teardown methods" do
    before do
      @result = Test::Unit::TestResult.new
      @test = sample_test.new("test: lifecycle foo")
      
      @test.class.setup do
        @one = 1
      end
      
      @test.class.teardown do
        @two = 10
      end
      
      @test.run(@result) { |inherited_after_each_var, v| }
    end
    
    it "runs setup method block a la Shoulda" do
      assert_equal 1, @test.one
    end
    
    it "runs setup method block and regular callbacks" do
      assert_equal 3, @test.inherited_before_each_var
    end
    
    it "runs teardown method block a la Shoulda" do
      assert_equal 10, @test.two
    end
    
    it "runs teardown method block and regular callbacks" do
      assert_equal 1, @test.after_each_var
    end
  end
end
