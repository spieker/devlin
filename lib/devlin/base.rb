module Devlin
  class Base
    def initialize(params)
      @params = params
    end

    # returns the keys of the defined scopes
    def self.scopes
      @scopes.keys
    end

    def self.[](name)
      @scopes[name.to_sym]
    end

    def scope(name)
      @scope ||= {}
      @scope[name.to_sym] ||= Scope.new(name, @params, &(self.class[name.to_sym]))
      @scope[name.to_sym]
    end

    def query(q)
      Query.new(self, q)
    end

    private
    def self.scope(name, &block)
      @scopes ||= {}
      @scopes[name.to_sym] = block
    end
  end
end
