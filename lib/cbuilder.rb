require 'blankslate'
require 'active_support/ordered_hash'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/enumerable'

class Cbuilder < BlankSlate
  #Yields a builder and automatically turns the result into a CSV file
  def self.encode
    new._tap { |cbuilder| yield cbuilder }.target!
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

  if RUBY_VERSION > '1.9'
    def call(*args)
      case
      when args.one?
        array!(args.first) { |json, element| yield json, element }
      when args.many?
        extract!(*args)
      end
    end
  end

  # Returns the attributes of the current builder.
  def attributes!
    @attributes
  end
  
  # Encodes the current builder as CSV.
  def target!
    #FasterCSV.generate @attributes
    if RUBY_VERSION > '1.9'
      #Output with ruby's CSV
    else
      #Output with FasterCSV
    end
  end

  private
    def method_missing(method, *args)
      case
      # csv.comments @post.comments { |csv, comment| ... }
      # comments, ...
      # "comment1, comment2, ...", ...
      when args.one? && block_given?
        # todo: implement

      # csv.age 32
      # age, ...
      # 32, ...
      when args.length == 1
        #todo: implement

      # csv.comments { |csv| ... }
      # comments, ...
      # " ... ", ...
      when args.empty? && block_given?
        # todo: implement
      
      # csv.comments(@post.comments, :content, :created_at)
      # comments, ...
      # "content: hello, created_at:, ...", ...
      when args.many? && args.first.is_a?(Enumerable)
        # todo: implement

      # csv.author @post.creator, :name, :email_address
      # author, ...
      # "name: Nate, email: nate.berkopec@gmail.com", ...
      when args.many?
        # todo: implement
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

end

require 'cbuilder_template' if defined? ActionView::Template