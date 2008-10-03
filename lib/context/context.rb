class Test::Unit::TestCase
  class << self
    def context_name
      @context_name ||= ""

      if superclass.respond_to?(:context_name) && !superclass.context_name.nil?
        "#{superclass.context_name}#{" " unless superclass.context_name == "" || @context_name == ""}#{@context_name}"
      else
        @context_name
      end
    end

    def context_name=(val)
      @context_name = val
    end

    def context(name, &block)
      self.context_name = name
      Class.new(self, &block)
    end

    %w(contexts describe describes group specify specifies).each {|m| alias_method m, :context}
  end
end