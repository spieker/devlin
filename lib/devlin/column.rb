module Devlin
  class Column
    def initialize(name, config)
      @name = name
      @config = config
    end

    def select_definition
      "#{@config[:definition]} AS #{@name}"
    end

    def definition
      @config[:definition]
    end

    def value(value)
      if @config[:getter].respond_to?(:call)
        @config[:getter].call(value)
      else
        value
      end
    end
  end
end
