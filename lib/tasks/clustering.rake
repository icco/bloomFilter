namespace :data do
   desc "Init the clusters."
   task :cluster => :environment do
      k = 10

      (0..k).each do |i|
         c = Cluster.where(:id => i + 1).first
         c = Cluster.new if c.nil?
         c.save

         Centroid.factory c, User.find(i+1), 1
      end

      (0..5).each do |i|
         Cluster.rebuild
         Item.where(:cluster_id => nil).limit(100).each do |item|
            item.cluster = Cluster.closest(item)
            item.save
         end
      end
   end
end
