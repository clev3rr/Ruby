def cut_cake(cake)
  k = cake.count('o')
  cake = cake.split("\n")
  n, m = cake.size, cake[0].size
  area = n * m
  area, r = area.divmod(k)
  return [] unless r.zero?

  dims = (1..[Math.sqrt(area).floor, n].min).each_with_object([]) do |i, a|
    next if area % i > 0
    j = area / i
    next if j > m
    a << i
    a << j unless i == j
  end
  dims.sort!

  accum = []
  recf = -> cake do
    res = y = nil
    if (x = cake.find_index { |r| y = /\S/ =~ r })
      dims.each_with_index do |k, i|
        l = dims[~i]
        if x + k <= n && y + l <= m
          slice = cake[x...x + k].map { |r| r[y...y + l] }.join("\n")
          if !slice.include?(' ') && slice.count('o') == 1
            accum << slice
            re = /(?<=.{#{y}})\S{#{l}}/
            sliced = cake.map.with_index { |r, i| x <= i && i < x + k ? r.sub(re, ' ' * l) : r }
            break if (res = recf.(sliced))
            accum.pop
          end
        end
      end
      res
    else
      true
    end
  end

  recf.(cake) ? accum : []
end

def generate_cake(rows, cols, raisins)
  raise "Кількість родзинок має бути 2..9" unless (2..9).include?(raisins)

  cake = Array.new(rows) { "." * cols }

  positions = []
  while positions.size < raisins
    x = rand(rows)
    y = rand(cols)
    positions << [x, y] unless positions.include?([x, y])
  end

  positions.each do |x, y|
    cake[x][y] = "o"
  end

  cake.join("\n")
end

def print_solution(cake, solution)
  puts "Торт:"
  puts cake
  if solution.empty?
    puts "\nНе можна розрізати за умовами."
  else
    puts "\nМожна розрізати на #{solution.size} шматків:"
    solution.each_with_index do |piece, i|
      puts "\nШматок #{i + 1}:"
      puts piece
    end
  end
end

# === Використання ===
cake = generate_cake(6, 8, 4)   # торт 6х8 з 4 родзинками
solution = cut_cake(cake)       # пробуємо розрізати
print_solution(cake, solution)
