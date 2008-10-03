class Test::Unit::TestCase
  class << self
    # Tweaks to standard method so we don't get superclass methods and we don't
    # get weird default tests
    def suite
      method_names = public_instance_methods(false)
      tests = method_names.delete_if {|method_name| method_name !~ /^test./}
      suite = Test::Unit::TestSuite.new(name)
      
      tests.sort.each do |test|
        catch(:invalid_test) do
          suite << new(test)
        end
      end
      
      suite
    end
  end
end