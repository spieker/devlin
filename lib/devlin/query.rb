module Devlin
  class Query
    attr_reader :query, :scope, :scope_name

    def initialize(parent, q)
      @parent = parent
      @query = YAML.load(q)
      @scope = parent.scope(query['scope'])
      @scope_name = query['scope']
      @select = query['select']
      @conditions = query['conditions']
      @group = query['group']
      @order = query['order']
    end

    # This method returns the resulting relation to calculate the given
    # query
    def result
      res = @scope.relation
      res = res.select(self.select.map { |c| @scope.column(c).select_definition })
      self.conditions.each do |col, val|
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
      self.order.each do |col, val|
        res = res.order("#{@scope.column(col).definition} #{val}")
      end
      res
    end # def result

    def select
      @select or raise "No selection columns given"
    end # def select

    def conditions
      @conditions || {}
    end # def conditions

    def group
      @group || []
    end # def group

    def order
      res = {}
      (@order || {}).each do |key, value|
        res[key] = case value.to_s.downcase
                   when 'desc'
                     'DESC'
                   else
                     'ASC'
                   end
      end
      res
    end
  end
end
