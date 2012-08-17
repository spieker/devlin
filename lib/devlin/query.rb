module Devlin
  class Query
    attr_reader :query, :scope, :select, :conditions, :group

    def initialize(parent, q)
      @parent = parent
      @query = YAML.load(q)
      @scope = parent.scope(query['scope'])
      @select = query['select']
      @conditions = query['conditions']
      @group = query['group']
    end

    # This method returns the resulting relation to calculate the given
    # query
    def result
      res = @scope.relation
      res = res.select(self.select.map { |c| @scope.column(c).select_definition })
      @conditions.each do |col, val|
        res = res.where(["#{@scope.column(col).definition}=?", val.to_s])
      end
      res = res.group(self.group.map { |c| @scope.column(c).definition })
      res
    end
  end
end
