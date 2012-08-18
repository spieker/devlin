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
      order:
        month: asc
        manufacturer: desc
    EOF
  end

  describe 'query' do
    it 'should contain the given query' do
      rep = TestReport.new user_id: 1
      rep.query(@q).scope.should eq(rep.scope(:transaction))
      rep.query(@q).select.should eq(['month', 'manufacturer', 'earnings'])
      rep.query(@q).conditions.should eq('year' => 2012, 'month.geq' => 8, 'month.leq' => 10)
      rep.query(@q).group.should eq(['manufacturer', 'month'])
      rep.query(@q).order.should eq('month' => 'ASC', 'manufacturer' => 'DESC')
    end # it

    it 'should return an exception if no selections are given' do
      rep = TestReport.new user_id: 1
      expect {
        rep.query('scope: transaction').select
      }.should raise_error
    end

    it 'should return an empty hash if no conditions are given' do
      rep = TestReport.new user_id: 1
      rep.query('scope: transaction').conditions.should be_a(Hash)
      rep.query('scope: transaction').conditions.should be_empty
    end
    
    it 'should return an empty hash if no conditions are given' do
      rep = TestReport.new user_id: 1
      rep.query('scope: transaction').group.should be_an(Array)
      rep.query('scope: transaction').group.should be_empty
    end
    
    it 'should return an empty hash if no order is given' do
      rep = TestReport.new user_id: 1
      rep.query('scope: transaction').order.should be_a(Hash)
      rep.query('scope: transaction').order.should be_empty
    end

    describe 'result' do
      it 'should only contain the selected columns' do
        rep = TestReport.new user_id: 1
        rep.query(@q).result.first.attributes.keys.map(&:to_sym).should eq([:month, :manufacturer, :earnings])
      end # it

      it 'should contain only results with months between 1 and 3' do
        rep = TestReport.new user_id: 1
        rep.query(@q).result.each do |r|
          r.month.to_i.should be_between(8, 10)
        end
      end # it
    end # describe 'result'
  end # describe 'query'
end
