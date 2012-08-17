require 'rubygems'
require 'bundler/setup'
require 'devlin'
require 'sqlite3'
require 'pry'
require 'factory_girl'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

RSpec.configure do |config|
  config.mock_with :rspec
  config.before :each do
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
  end
  config.after :each do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end
end

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "#{root}/spec/test.sqlite3"
)

class TestReport < Devlin::Base
  scope :transaction do |scope|
    relation Transaction.where(user_id: scope.params[:user_id]).scoped
    
    column :manufacturer, "manufacturer"
    column :year, "strftime('%Y', date)"
    column :month, "strftime('%m', date)" do |value|
      months = %W(~ Jan Feb Mar Apr May Jun Jul Aug Sep Okt Nov Dec)
      months[value]
    end
    column :earnings, "SUM(costs)"
  end
end

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'transactions'")
ActiveRecord::Base.connection.create_table(:transactions) do |t|
  t.integer   :user_id
  t.string    :manufacturer
  t.datetime  :date
  t.float     :costs
end
class Transaction < ActiveRecord::Base
end

FactoryGirl.find_definitions
