module Math
   def Math.variance(population)
      n = 0
      mean = 0.0
      s = 0.0

      population.each do |x|
         n = n + 1
         delta = x - mean
         mean = mean + (delta / n)
         s = s + delta * (x - mean)
      end

      return s / n
   end

   def Math.mean(population)
      if population.size == 0
         return 0
      else
         return population.inject{ |sum, el| sum + el }.to_f / population.size
      end
   end

   def Math.standard_deviation(population)
      Math.sqrt(Math.variance(population))
   end
end
