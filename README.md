# Devlin

Devlin gives users the ability to define reporting database queries. 
The queries are defined in yaml and using predefined scopes. Since 
the sql statements are defined by the developer, the user is not able 
to corrupt the database.

## Installation

Add this line to your application's Gemfile:

    gem 'devlin', :git => 'https://github.com/spieker/devlin.git'

And then execute:

    $ bundle

## Usage

First you have to setup Devlin and define base scopes which can be used
to define queries. In Rails you can do this in an initializer.

    # config/initializers/devlin.rb
   
    class ReportBuilder < Devlin::Base 
      scope :transaction do |params|
        relation Transaction.where(user_id: params[:user_id]).scoped
        
        column :manufacturer, "manufacturer"
        column :year, "YEAR(date)"
        column :month, "MONTH(date)" do |value|
          months = %W(~ Jan Feb Mar Apr May Jun Jul Aug Sep Okt Nov Dec)
          months[value]
        end
        column :earnings, "SUM(costs*IF(direction='in', -1, 1))"
      end

      # more scopes ...
    end

Now you can define queries on the configured scopes

    # app/controllers/report_controller.rb

    ...
    def report
      @relation = Devlin.new(user_id: current_user.id).query(params[:q]).result
    end
    ...

The parameter "q" has to contain the query defined in yaml. The query
can look like this:

    scope: transaction
    select:
      - manufacturer
      - month
      - earnings
    conditions:
      year: 2012
    group:
      - manufacturer
      - month

The generated query returns a sum of earnings for each manufacturer and
each month in the year 2012.

## Todo

* Params for columns to have i.e. one column for each month and a list
  of manufacturers


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
