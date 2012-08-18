module Devlin
  class Column
    attr_reader :name, :config

    def initialize(name, config, *args)
      @name = name
      @config = config
      @arguments = args.extract_options!
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

    def human_attribute_name
      I18n.t(self.name, scope[:devlin, config[:scope].name])
    end

    def arguments
      @arguments
    end
  end
end
