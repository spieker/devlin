require 'spec_helper'

describe TestReport do
  it 'should contain all configured scopes' do
    TestReport.scopes.should eq([:transaction])
  end

  describe 'transaction scope' do
    it 'should have a relation' do
      rep = TestReport.new(user_id: 1)
      scope = rep.scope(:transaction)
      scope.relation.class.should eq(ActiveRecord::Relation)
    end

    it 'should have all configured columns' do
      rep = TestReport.new(user_id: 1)
      scope = rep.scope(:transaction)
      scope.columns.should eq([:manufacturer, :year, :month, :earnings])
    end

    describe 'column' do
      it 'should return the column definition including "AS"' do
        rep = TestReport.new(user_id: 1)
        scope = rep.scope(:transaction)
        scope.column(:manufacturer).select_definition.should eq('manufacturer AS manufacturer')
        scope.column(:year).select_definition.should eq("CAST(strftime('%Y', date) AS INTEGER) AS year")
      end

      it 'should return the column value as is, if no getter is defined' do
        rep = TestReport.new(user_id: 1)
        scope = rep.scope(:transaction)
        scope.column(:manufacturer).value('hallo welt').should eq('hallo welt')
      end

      it 'should return the value calculated by the getter method if defined' do
        rep = TestReport.new(user_id: 1)
        scope = rep.scope(:transaction)
        scope.column(:month).value(2).should eq('Feb')
      end
    end
  end
end
