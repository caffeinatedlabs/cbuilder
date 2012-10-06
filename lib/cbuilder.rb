require 'active_support/basic_object'
require 'active_support/ordered_hash'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/enumerable'
require 'csv'

class Cbuilder < ActiveSupport::BasicObject
  #Yields a builder and automatically turns the result into a CSV file
  def self.encode(*args)
    cbuilder = new(*args)
    yield cbuilder
    cbuilder.target!
  end

  def initialize
    @attributes, @headers = ::Array.new, ::Array.new
  end

  def set!(column, value)
    @headers.push column unless @headers.include?(column)
    @attributes.push value
  end
  alias_method :col, :set!

  def set_collection!(collection)
    @collection = collection
    @attributes = if ::Kernel::block_given?
      _map_collection(collection) { |element| if ::Proc.new.arity == 2 then yield self, element else yield element end }
    else
      collection
    end
  end
  
  # Encodes the current builder as CSV.
  def target!
    if ::RUBY_VERSION > '1.9'
      ::CSV.generate do |csv|
        csv << @headers # header row
        @attributes.each do |element| # body rows
          csv << (element.nil? ? '' : element)
        end
      end
    else
      FasterCSV.generate do |csv|
        csv << @headers # pop header row
        @attributes.each do |element| # body rows
          csv << (element.nil? ? '' : element)
        end
      end
    end
  end

  private
    def _evaluate_for(element, values)
      values.map { |value| element.send(value)}
    end

    def _map_collection(collection)
      collection.each.map do |element|
        _scope { yield element }
      end
    end

    def _scope
      parent_attributes = @attributes
      @attributes = ::Array.new
      yield
      @attributes
    ensure
      @attributes= parent_attributes
    end

end

require 'cbuilder_template' if defined? ActionView::Template