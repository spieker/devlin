require 'spec_helper'

describe TestReport do
  before :each do
    100.times do |i|
      FactoryGirl.create :transaction, date: Date.parse('2012-08-18')+i.days
      FactoryGirl.create :transaction, date: Date.parse('2012-08-18')+i.days, manufacturer: 'M2'
    end
    @q = <<-EOF
      scope: transaction
      select:
        - month
        - manufacturer
        - earnings
      conditions:
        year: 2012
        month.geq: 8
        month.leq: 10
      group:
        - manufacturer
        - month
    EOF
  end

  describe 'query' do
    it 'should contain the given query' do
      rep = TestReport.new user_id: 1
      rep.query(@q).scope.should eq(rep.scope(:transaction))
      rep.query(@q).select.should eq(['month', 'manufacturer', 'earnings'])
      rep.query(@q).conditions.should eq('year' => 2012, 'month.geq' => 8, 'month.leq' => 10)
      rep.query(@q).group.should eq(['manufacturer', 'month'])
    end

    describe 'result' do
      it 'should only contain the selected columns' do
        rep = TestReport.new user_id: 1
        rep.query(@q).result.first.attributes.keys.map(&:to_sym).should eq([:month, :manufacturer, :earnings])
      end

      it 'should contain only results with months between 1 and 3' do
        rep = TestReport.new user_id: 1
        rep.query(@q).result.each do |r|
          r.month.to_i.should be_between(8, 10)
        end
      end
    end
  end
end
