class CbuilderTemplate < Cbuilder
  def self.encode(context)
    new(context)._tap { |cbuilder| yield cbuilder }.target!
  end

  def initialize(context)
    @context = context
    super()
  end

  def partial!(options, locals = {})
    case options
    when Hash
      options[:locals] ||= {}
      options[:locals].merge!(:csv => self)
      @context.render(options)
    else
      @context.render(options, locals.merge(:csv => self))
    end
  end

  private
    def _new_instance
      __class__.new(@context)
    end
end

class CbuilderHandler
  cattr_accessor :default_format
  self.default_format = Mime::CSV

  def self.call(template)
    %{
      if defined?(csv)
        #{template.source}
      else
        CbuilderTemplate.encode(self) do |csv|
          #{template.source}
        end
      end
    }
  end
end

ActionView::Template.register_template_handler :cbuilder, CbuilderHandler