class Test::Unit::TestCase
  class << self
    def context_name #:nodoc:
      @context_name ||= ""
      if superclass.respond_to?(:context_name)
        return "#{superclass.context_name} #{@context_name}".gsub(/^\s+/, "")
      end
    end

    def context_name=(val) #:nodoc:
      @context_name = val
    end

    # Add a context to a set of tests.
    # 
    #   context "A new account" do
    #     it "should not have users"
    #       assert Account.new.users.empty?
    #     end
    #   end
    # 
    # The context name is prepended to the test name, so failures look like this:
    # 
    #   1) Failure:
    #   test_a_new_account_should_not_have_users() [./test/test_accounts.rb:4]:
    #   <false> is not true.
    # 
    # Contexts can also be nested like so:
    # 
    #   context "A new account" do
    #     context "created by the web application" do
    #       it "should have web as its vendor" do
    #         assert_equal "web", users(:web_user).vendor
    #       end
    #     end
    #   end
    # 
    # Since contexts create a singleton instance of a class, each one must have its own before/after blocks.  This
    # will be tweaked in future releases to allow you to chain these blocks from its parent contexts.
    #
    def context(name, &block)
      cls = Class.new(self)
      cls.context_name = name
      puts "Creating context #{cls.context_name}"
      cls.class_eval(&block)
      
      cls
    end

    %w(contexts describe describes group specify specifies).each {|m| alias_method m, :context}
  end
end