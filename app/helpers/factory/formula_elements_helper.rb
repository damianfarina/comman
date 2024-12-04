module Factory::FormulaElementsHelper
  RED = "#EE6054".freeze
  YELLOW = "#FFC233".freeze
  GREEN = "#60D394".freeze

  def stock_level_color(percentage)
    percentage = [ [ percentage, 0 ].max, 100 ].min # Clamp percentage between 0 and 100
    case percentage
    when 0..50
      interpolate_color(RED, YELLOW, percentage / 50.0) # Red → Yellow
    when 51..100
      interpolate_color(YELLOW, GREEN, (percentage - 50) / 50.0) # Yellow → Green
    end
  end

  def interpolate_color(start_color, end_color, ratio)
    ratio = [ [ ratio, 0 ].max, 1 ].min # Clamp ratio between 0 and 1
    start_rgb = start_color.match(/#(..)(..)(..)/).captures.map { |c| c.to_i(16) }
    end_rgb = end_color.match(/#(..)(..)(..)/).captures.map { |c| c.to_i(16) }
    interpolated_rgb = start_rgb.zip(end_rgb).map do |start, finish|
      ((finish - start) * ratio + start).round
    end
    "rgb(#{interpolated_rgb.join(",")})"
  end
end
