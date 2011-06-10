class Cluster < ActiveRecord::Base
   has_many :items
   has_many :centroids, :order => "user_id ASC"

   def distance item
      dist = 0.0
      self.centroids.each do |centroid|
         val = item.user_voted?(centroid.user) ? 1 : 0
         dist += ((centroid.average - val) ** 2)
      end

      dist = Math.sqrt(dist)

      return dist
   end

   def Cluster.closest item
      closest = nil
      Cluster.all.each do |cluster|
         d = cluster.distance item
         if closest.nil? or d < closest.distance(item)
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
            Item.limit(10).each do |item|
               item.cluster = Cluster.closest(item)
               item.save
            end
         end

         # Take the centroid
         sum_vector = Hash.new
         sum_vector.default = 0.0

         cluster.items.each do |item|
            item.votes.group('user_id').count.each do |userid, count|
               sum_vector[userid] = count
            end
         end

         sum_vector = sum_vector.map do |key, count|
            [key, (count / cluster.items.count)]
         end

         sum_vector.each do |user, avg|
            Centroid.factory(cluster, user, avg) if avg > 0
         end
      end

      return true
   end
end
