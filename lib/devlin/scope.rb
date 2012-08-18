module Devlin
  class Scope
    # The configuration object simplifies the configuration of the scope
    class Config
      attr_reader :params

      def initialize(scope, params, &block)
        @scope = scope
        @params = params
        instance_eval(&block)
      end

      def relation(rel)
        @scope.relation = rel  
      end

      def column(name, definition, *args, &block)
        @scope.add_column(name, definition, *args, &block)
      end
    end

    attr_accessor :relation

    def initialize(params, &block)
      Config.new(self, params, &block)
    end

    # add a column definition to the scope
    def add_column(name, definition, *args, &block)
      @columns ||= {}
      @columns[name.to_sym] = Column.new(name, {
        definition: definition,
        getter: block
      }, *args)
    end

    def columns
      @columns ||= {}
      @columns.keys
    end

    def column(name)
      @columns ||= {}
      column = @columns[name.to_sym]
      raise "no column '#{name}' found" if column.blank?
      column
    end
    
  end
end
