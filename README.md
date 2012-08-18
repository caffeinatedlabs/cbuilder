# cbuilder

cbuilder is a CSV builder inspired by dhh's excellent jbuilder. The goal is a
simple DSL for creating CSV files that's better than creating massive custom arrays.

If you're doing any more than 4-5 columns, generating CSV files can be a real pain. 
God forbid you're not simply outputting the attributes of a simple array, and need
helpers or other niceties.

cbuilder is here to make it easier.

Have you ever found yourself doing this?

    Name,Products Purchased, 
    <% @orders.each do |order|%>
    <%= order.customer.name %>,<%= products_count(order) %>,<%= customer_lastname(order) %>,...
    <% end %>

What if you could do this instead?
    Cbuilder.encode(@orders) do
      "Customer Name"         name
      "Products Purchased"    helper(products_count)
      "Product Names"         products :name
      ...                     ...
    end

Or maybe Builder is more your style?

    Cbuilder.encode(@orders) do |csv|
      csv.name
      csv.column        "Products Purchased" helper(products_count)
      csv.product_names products :name
      ...
    end

## Installation

Add this line to your application's Gemfile:

    gem 'cbuilder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cbuilder

## Usage

This is not working yet. I'll fill in these instructions when this actually works.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
