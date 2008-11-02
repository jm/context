require File.dirname(__FILE__) + '/test_helper.rb'

class TestLifecycle < Test::Unit::TestCase
  before do
    @a = 1
  end

  before do
    @a = 2
    @b = 1
  end

  after do
    @c = 1
  end

  before :all do
    @e = 1
  end

  after :all do
    @f = 1
  end

  sample_test = context "lifecycle" do
    attr_reader :a, :b, :c, :d, :e, :f, :g, :h

    before do
      @a = 3
    end

    after do
      @d = 1
    end

    before :all do
      @g = 1
    end

    after :all do
      @h = 1
    end

    test "foo" do
    end
  end

  context "With before/after :each blocks" do
    before do
      @result = Test::Unit::TestResult.new
      @test = sample_test.new("test_lifecycle_foo")
      @test.run(@result) { |c, v| }
    end

    it "it runs inherited before callbacks in order" do
      assert_equal 3, @test.a
    end

    it "it runs before callbacks in order" do
      assert_equal 1, @test.b
    end

    it "it runs inherited after callbacks" do
      assert_equal 1, @test.c
    end

    it "it runs after callbacks" do
      assert_equal 1, @test.d
    end
  end

  context "With before/after :all blocks" do
    before do
      @result = Test::Unit::TestResult.new
      @suite  = sample_test.suite
      @suite.run(@result) { |c, v| }
      @test   = @suite.tests.first
    end

    it "it runs inherited before callbacks in order" do
      assert_equal 1, @test.e
    end

    it "it runs before callbacks in order" do
      assert_equal 1, @test.g
    end

    it "it runs inherited after callbacks" do
      assert_equal 1, @test.f
    end

    it "it runs after callbacks" do
      assert_equal 1, @test.h
    end
  end
end
