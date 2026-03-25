module Components
  module BentoHelper
    # Bento 그리드 컨테이너
    # Usage: <%= bento_grid class: "mt-12" do %>...content...<% end %>
    def bento_grid(**attrs, &block)
      custom_class = attrs.delete(:class) || ""
      classes = tw(
        "grid gap-6 md:gap-8",
        "grid-cols-1 md:grid-cols-2 lg:grid-cols-3", # Simple 3-column grid
        custom_class
      )
      content_tag :div, class: classes, **attrs, &block
    end

    # Bento 블록 - Simplified, cleaner cards
    # Usage: <%= bento_block size: "2x2", class: "cursor-pointer" do %>...content...<% end %>
    def bento_block(size: "1x1", **attrs, &block)
      custom_class = attrs.delete(:class) || ""
      span_classes = bento_span_classes(size)
      classes = tw(
        "rounded-2xl border border-gray-200 bg-white",
        "hover:shadow-lg transition-all duration-200",
        "p-8 flex flex-col gap-4 overflow-hidden group",
        span_classes,
        custom_class
      )
      content_tag :div, class: classes, **attrs, &block
    end

    private

    def bento_span_classes(size)
      case size
      when "1x1" # Regular - 1 column
        "col-span-1"
      when "2x1", "wide" # Wide - 2 columns
        "col-span-1 md:col-span-2"
      when "full" # Full width - all columns
        "col-span-1 md:col-span-2 lg:col-span-3"
      else
        "col-span-1"
      end
    end
  end
end
