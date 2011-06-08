class Cluster < ActiveRecord::Base
   has_many :items
   belongs_to :point, :class_name => 'Item', :foreign_key => 'item_id'

   def Cluster.closest item
      closest = nil
      Cluster.all.each do |cluster|
         d = cluster.point.distance item
         if closest.nil? or d < closest.point.distance(item)
            closest = cluster
         end
      end

      return closest
   end

   def Cluster.rebuild
      # http://en.wikipedia.org/wiki/K-means_clustering#Standard_algorithm
      #
      # 1) Associate each item with a cluster (The one it's closest to?)
      # 2) Take the centroid of the items associated with each cluster (Which will no longer be a real point...)
      # 3) Repeat.

      Cluster.all.each do |cluster|

         if cluster.items.count == 0
            Item.limit(100).each do |item|
               item.cluster = Cluster.closest(item)
               item.save
            end
         end

         # Take the centroid
         sum_vector = Array.new(User.count, 0.0)
         cluster.items.each do |item|
            item.votes.select("user_id").each do |v|
               sum_vector[v.user_id] = 0 if sum_vector[v.user_id].nil?
               sum_vector[v.user_id] = sum_vector[v.user_id] + 1
            end
         end

         sum_vector.map! do |count|
            count / sum_vector.size
         end

         # Set that as the new cluster

      end

      return true
   end
end
