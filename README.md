# cbuilder

cbuilder is a CSV builder inspired by dhh's excellent jbuilder. The goal is a
simple DSL for creating CSV files that's better than creating massive custom arrays.

Have you ever found yourself doing this?

    Name,First,Last,Company,Address 1,...
    <% @orders.each do |order|%>
    <%= order.customer.name %>,<%= customer_firstname(order) %>,<%= customer_lastname(order) %>,...
    <% end %>

What if you could do this instead?

    csv.name        order.customer.name
    csv.first_name  customer_fullname(order)
    csv.last_name   customer_lastname(order)
    ...

If you're doing any more than 4-5 columns, generating CSV files can be a real pain. 
God forbid you're not simply outputting the attributes of a simple array, and need
helpers or other niceties.

cbuilder is here to make it easier.

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
