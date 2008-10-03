class Test::Unit::TestCase
  class << self
    def test(name, &block)
      test_name = "test_#{((superclass.context_name ? (superclass.context_name + " ") : "") + name).to_method_name}".to_sym
      
      defined = instance_method(test_name) rescue false
      raise "#{test_name} is already defined in #{self}" if defined
      
      if block_given?
        define_method(test_name, &block)
      else
        define_method(test_name) do
          flunk "No implementation provided for #{name}"
        end
      end
    end
    
    %w(it should tests).each {|m| alias_method m, :test} 
  end
end