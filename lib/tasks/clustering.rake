namespace :data do
   desc "Init the clusters."
   task :cluster => :environment do
      k = 10

      # Pick 10 random points (Not cached)
      items = Item.find_by_sql("SELECT * FROM items WHERE id in (SELECT item_id FROM votes GROUP BY item_id HAVING COUNT(*) > 3) ORDER BY RANDOM() LIMIT #{k}")

      items.each_index do |i|
         c = Cluster.find(i)
         c = Cluster.new if c.nil?
         c.point = item
         c.save
      end

      # So, this will compute all of the distances and cache them...
      Cluster.all.each do |point|
         Item.all.each do |item|
            item.distance point
         end
      end
   end
end
