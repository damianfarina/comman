module Factory::FormulaElementsHelper
	def calculate_percentage_color(element)
		start_triplet = rgb_to_hsv(255, 0, 0) #comment: accordingly for red
		end_triplet = rgb_to_hsv(0, 255, 0) #comment: green converted to HSV

	  rgb = hsv_to_rgb(*transition3(element.current_stock_percentage, 100, *start_triplet, *end_triplet))
	  "rgb(#{rgb[0].round}, #{rgb[1].round}, #{rgb[2].round})"
	end

	def calculate_percentage_width(element)
		width = element.current_stock_percentage.round rescue 0
		width += 1 if width.zero?
		width
	end

	def rgb_to_hsv(r, g, b)
    maxc = [r, g, b].max
    minc = [r, g, b].min
    v = maxc
    return [0, 0, v] if minc == maxc
    diff = maxc - minc
    s = diff / maxc
    rc = (maxc - r) / diff
    gc = (maxc - g) / diff
    bc = (maxc - b) / diff
    if r == maxc
      h = bc - gc
    elsif g == maxc
      h = 2.0 + rc - bc
    else
      h = 4.0 + gc - rc
    end
    h = (h / 6.0) % 1.0 #comment: this calculates only the fractional part of h/6
    return [h, s, v]
  end

def hsv_to_rgb(h, s, v)
    return [v, v, v] if s == 0.0
    i = (h * 6.0).floor.to_i #comment: floor() should drop the fractional part
    f = (h * 6.0) - i
    p = v * (1.0 - s)
    q = v * (1.0 - s * f)
    t = v * (1.0 - s * (1.0 - f))
    return [v, t, p] if (i % 6) == 0
    return [q, v, p] if i == 1
    return [p, v, t] if i == 2
    return [p, q, v] if i == 3
    return [t, p, v] if i == 4
    return [v, p, q] if i == 5
    #comment: 0 <= i <= 6, so we never come here
  end

  def lerp(value, maximum, start_point, end_point)
    return start_point + (end_point - start_point) * value / maximum
  end

  def transition3(value, maximum, s1, s2, s3, e1, e2, e3)
    r1 = lerp(value, maximum, s1, e1)
    r2 = lerp(value, maximum, s2, e2)
    r3 = lerp(value, maximum, s3, e3)
    return [r1, r2, r3]
  end


  def formula_elements_to_csv(formula_elements)
    require 'csv'
    CSV.generate do |csv|
      csv << ['Nombre', 'Peso']
      formula_elements.each do |item|
        csv << [item.formula_element_name, item.consumed_stock]
      end
    end
  end

  def date_parts_to_date(query, key)
    date = Date.civil(query["#{key}(1i)"].to_i, query["#{key}(2i)"].to_i, query["#{key}(3i)"].to_i)
    date.strftime("%d/%m/%Y") if date
  end

end
