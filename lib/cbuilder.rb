require 'blankslate'
require 'active_support/ordered_hash'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/enumerable'
require 'csv'

class Cbuilder < BlankSlate
  #Yields a builder and automatically turns the result into a CSV file
  def self.encode(collection = nil)
    new._tap { |cbuilder| yield cbuilder }.target!(collection)
  end

  define_method(:__class__, find_hidden_method(:class))
  define_method(:_tap, find_hidden_method(:tap))

  def initialize
    @attributes = ActiveSupport::OrderedHash.new
  end

  # Dynamically set a column/value pair. 
  # Example: 
  # csv.set!(:username, "user")
  # csv.set!(:password, "secret")
  # username,password
  # user,secret
  def set!(column, value = nil)
    @attributes[column] = value
  end

  # Returns the attributes of the current builder.
  def attributes!
    @attributes
  end
  
  # Encodes the current builder as CSV.
  def target!(collection = nil)
    if RUBY_VERSION > '1.9'
      CSV.generate do |csv|
        csv << @attributes.keys # header row
        if collection.nil?
          csv << @attributes.values # body rows
        else
          collection.each do |element| # body rows
            csv << _evaluate_for(element, @attributes.values)
          end
        end
      end
    else
      FasterCSV.generate do |csv|
        csv << @attributes.keys
        csv << @attributes.values
      end
    end
  end

  private
    def method_missing(method, *args)
      case
      # csv.age 32
      # age, ...
      # 32, ...
      when args.length == 1
        set! method, args.first 

      # csv.comments { |csv| ... }
      # comments, ...
      # " ... ", ...
      when args.empty? && block_given?
        # todo: implement
      
      # csv.comments @post.comments, :content
      # comments, ...
      # "hello, world", ...
      when args.length == 2 && args.first.is_a?(Enumerable)
        set! method, args.first.map {|a| a.send(args[1])}.join(", ")

      end
    end

    # Overwrite in subclasses if you need to add initialization values
    # These methods stolen wholesale from the excellent jbuilder
    def _new_instance
      __class__.new
    end

    def _yield_nesting(container)
      set! container, _new_instance._tap { |jbuilder| yield jbuilder }.attributes!
    end

    def _inline_nesting(container, collection, attributes)
      __send__(container) do |parent|
        parent.array!(collection) and return if collection.empty?
        
        collection.each do |element|
          parent.child! do |child|
            attributes.each do |attribute|
              child.__send__ attribute, element.send(attribute)
            end
          end
        end
      end
    end
    
    def _yield_iteration(container, collection)
      __send__(container) do |parent|
        parent.array!(collection) do |child, element|
          yield child, element
        end
      end
    end
    
    def _inline_extract(container, record, attributes)
      __send__(container) { |parent| parent.extract! record, *attributes }
    end

    def _evaluate_for(element, values)
      values.map {|v| element.send(v)}
    end

end

require 'cbuilder_template' if defined? ActionView::Template