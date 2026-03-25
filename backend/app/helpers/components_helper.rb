require "tailwind_merge"

module ComponentsHelper
  # Include Bento Grid helper
  include Components::BentoHelper

  def tw(*classes)
    TailwindMerge::Merger.new.merge(classes.join(" "))
  end

  # 🎯 Button Styles (Enhanced)
  module Button
    BASE = "inline-flex items-center justify-center rounded-xl font-semibold transition-all duration-200 " \
           "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 " \
           "disabled:pointer-events-none disabled:opacity-50"

    PRIMARY = "#{BASE} bg-primary text-primary-foreground shadow-sm " \
              "hover:bg-primary/90 hover:shadow-md hover:scale-[1.02] active:scale-[0.98]"

    SECONDARY = "#{BASE} bg-secondary text-secondary-foreground border border-border " \
                "hover:bg-secondary/80 hover:border-border/60"

    OUTLINE = "#{BASE} border-2 border-input bg-transparent " \
              "hover:bg-accent hover:text-accent-foreground hover:border-primary/30"

    GHOST = "#{BASE} hover:bg-accent hover:text-accent-foreground"

    DESTRUCTIVE = "#{BASE} bg-destructive text-destructive-foreground shadow-sm " \
                  "hover:bg-destructive/90"

    LINK = "#{BASE} text-primary underline-offset-4 hover:underline"

    # Size variants
    SIZES = {
      sm: "h-9 px-3 text-sm",
      md: "h-10 px-4 py-2 text-base",
      lg: "h-12 px-6 text-lg",
      xl: "h-14 px-8 text-xl",
      icon: "h-10 w-10"
    }.freeze
  end

  # 🃏 Card Styles (Enhanced)
  module Card
    BASE = "group relative rounded-2xl border border-border bg-card text-card-foreground " \
           "shadow-sm transition-all duration-200"

    DEFAULT = "#{BASE} hover:shadow-md hover:border-border/60"
    ELEVATED = "#{BASE} shadow-md hover:shadow-xl"
    INTERACTIVE = "#{BASE} hover:-translate-y-1 cursor-pointer hover:shadow-lg"
    FLAT = "#{BASE} shadow-none border-border/50"
    GHOST = "border-0 shadow-none bg-transparent"
  end

  # 📝 Input Styles (Enhanced)
  module Input
    BASE = "flex h-10 w-full rounded-xl border border-input bg-background px-3 py-2 " \
           "text-sm transition-all duration-200 file:border-0 file:bg-transparent " \
           "file:text-sm file:font-medium placeholder:text-muted-foreground " \
           "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring " \
           "focus-visible:ring-offset-0 focus-visible:border-primary " \
           "disabled:cursor-not-allowed disabled:opacity-50 hover:border-border/60"

    ERROR = "border-destructive focus-visible:ring-destructive"
    SUCCESS = "border-success focus-visible:ring-success"
    WARNING = "border-warning focus-visible:ring-warning"
  end

  # 🚨 Alert Styles (Enhanced)
  module Alert
    BASE = "relative w-full rounded-xl border px-4 py-3 text-sm transition-all duration-200"

    INFO = "#{BASE} bg-blue-50 border-blue-200 text-blue-900 [&>svg]:text-blue-600"
    SUCCESS = "#{BASE} bg-green-50 border-green-200 text-green-900 [&>svg]:text-green-600"
    WARNING = "#{BASE} bg-amber-50 border-amber-200 text-amber-900 [&>svg]:text-amber-600"
    ERROR = "#{BASE} bg-red-50 border-red-200 text-red-900 [&>svg]:text-red-600"
    DEFAULT = "#{BASE} bg-background border-border text-foreground"
  end

  # 🏷️ Badge Styles (New)
  module Badge
    BASE = "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold " \
           "transition-colors duration-200"

    DEFAULT = "#{BASE} bg-primary text-primary-foreground"
    SECONDARY = "#{BASE} bg-secondary text-secondary-foreground border border-border"
    OUTLINE = "#{BASE} border border-input bg-transparent"
    SUCCESS = "#{BASE} bg-green-100 text-green-800 border border-green-200"
    WARNING = "#{BASE} bg-amber-100 text-amber-800 border border-amber-200"
    DESTRUCTIVE = "#{BASE} bg-red-100 text-red-800 border border-red-200"
  end

  # Legacy support
  PRIMARY_CLASSES = Button::PRIMARY
  SECONDARY_CLASSES = Button::SECONDARY
  OUTLINE_CLASSES = Button::OUTLINE
  GHOST_CLASSES = Button::GHOST
  DESTRUCTIVE_CLASSES = Button::DESTRUCTIVE
end
