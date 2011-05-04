# A nice little function for the time since an event.
class Time
   def time_since
      distance = Time.now.to_i - self.to_i

      out = case distance
            when 0 .. 59 then "#{distance} seconds ago"
            when 60 .. (60*60) then "#{distance/60} minutes ago"
            when (60*60) .. (60*60*24) then "#{distance/(60*60)} hours ago"
            when (60*60*24) .. (60*60*24*30) then "#{distance/((60*60)*24)} days ago"
            else Time.at(date).strftime("%m/%d/%Y")
            end

      out.sub(/^1 (\w+)s ago$/, 'one \1 ago')
   end
end
