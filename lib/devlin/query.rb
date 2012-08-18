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
        col, op = col.split('.')
        res = case op
        when 'g'
          res.where(["#{@scope.column(col).definition}>?", val])
        when 'geq'
          res.where(["#{@scope.column(col).definition}>=?", val])
        when 'l'
          res.where(["#{@scope.column(col).definition}<?", val])
        when 'leq'
          res.where(["#{@scope.column(col).definition}<=?", val])
        when 'in'
          res.where(["#{@scope.column(col).definition} IN (?)", val])
        else
          res.where(["#{@scope.column(col).definition}=?", val])
        end
      end
      res = res.group(self.group.map { |c| @scope.column(c).definition })
      res
    end
  end
end
