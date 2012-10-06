class CbuilderTemplate < Cbuilder
  def initialize(context, *args)
    @context = context
    super(*args)
  end

  def partial!(options, locals = {})
    case options
    when Hash
      options[:locals] ||= {}
      options[:locals].merge!(:csv => self)
      @context.render(options.reverse_merge(:formats => [:csv]))
    else
      @context.render(:partial => options, :locals => locals.merge(:csv => self), :formats => [:csv])
    end
  end
end

class CbuilderHandler
  cattr_accessor :default_format
  self.default_format = Mime::CSV

  def self.call(template)
    %{__already_defined = defined?(csv); csv||=CbuilderTemplate.new(self); #{template.source}
      csv.target! unless __already_defined}
  end
end

ActionView::Template.register_template_handler :cbuilder, CbuilderHandler