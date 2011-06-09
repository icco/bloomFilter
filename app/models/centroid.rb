class Centroid < ActiveRecord::Base
   belongs_to :cluster
   belongs_to :user

   def Centroid.factory cluster, user, avg
      if avg > 0
         c = Centroid.where(:cluster_id => cluster, :user_id => user).first

         if c.nil?
            c = Centroid.new
            if cluster.is_a? Fixnum
               c.cluster_id = cluster
            else
               c.cluster = cluster
            end

            if user.is_a? Fixnum
               c.user_id = user
            else
               c.user = user
            end
         end

         c.average = avg
         c.save

         return c
      else
         return nil
      end
   end
end
