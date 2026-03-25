module Components::AccordionHelper
  def accordion_title(&block)
    content_for :title, capture(&block), flush: true
  end

  def accordion_description(&block)
    content_for :description, capture(&block), flush: true
  end

  def render_accordion(title: nil, description: nil, **options, &block)
    if title && !description
      content_for :description, capture(&block), flush: true
    elsif !title && !description
      capture(&block)
    end
    render "components/ui/accordion", title: title, description: description, options: options
  end
end
