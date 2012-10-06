# cbuilder

Cbuilder is an ultralight (< 100 LOC) CSV builder/template handler inspired by dhh's excellent
Jbuilder. The goal is a simple DSL for creating CSV files that's better than creating
massive custom arrays.

If you're doing any more than 4-5 columns, generating CSV files can be a real pain. 
God forbid you're not simply outputting the attributes of a simple array, and need
helpers or other niceties.

You don't need to re-invent the wheel with CSV. Cbuilder weighs in at less than 100 LOC.

Have you ever found yourself doing this?

```ruby
  Customer Name,Products Purchased, Product Names 
  <% @orders.each do |order|%>
  <%= order.customer.name %>,<%= products_count(order) %>,<%= product_names(order.products) %>,...
  <% end %>
```

What if you could do this instead?

```ruby
  Cbuilder.encode do |csv|
    csv.set_collection!(@orders) do |order|
      csv.col 'Customer Name',        order.customer.name
      csv.col 'Products Purchased',   products_count(order)
      csv.col 'Product Names',        product_names(order.products)
    end
  end
```

## Installation

Add this line to your application's Gemfile:

    gem 'cbuilder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cbuilder

## Usage

Just drop into your Rails Gemfile and start adding templates with *.csv.cbuilder.

If you'd like the CSV to be downloaded as an attachment, add the following to your
controller action:

```ruby
  response.headers["Content-Disposition"] = 'attachment; filename="my_spreadsheet.csv'
```

## TODO

* Test Ruby 1.8 support
* Test use as a partial

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

![http://i.imgur.com/Jd7pg.jpg](http://i.imgur.com/Jd7pg.jpg)

Cbuilder was built by [Craft Coffee](http://craftcoffee.com)
