
namespace :data do
   desc "Init the clusters."
   task :cluster => :environment do
      k = 10

      # Pick 10 random points (Not cached)
      items = Item.find_by_sql("SELECT * FROM items WHERE id in (SELECT item_id FROM votes GROUP BY item_id HAVING COUNT(*) > 3) ORDER BY RANDOM() LIMIT #{k}")

      items.each do |item|
         c = Cluster.new
         c.point = item
         c.save

         p c.point.voters.count
      end
   end
end
