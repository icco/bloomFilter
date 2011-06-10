namespace :data do
   desc "Dump our data for VW."
   task :dump => :environment do

      (1..5).each {|i| Cluster.rebuild }

      user = User.limit(1).order("random()").first

      Item.where(:cluster_id => 1).limit(100).each do |item|
         item.cluster = Cluster.closest(item)
         item.save
      end

      user.likes.each do |item|
         item.cluster = Cluster.closest(item)
         item.save
      end

      user.frontpage_items.each do |item|
         item.cluster = Cluster.closest(item)
         item.save
      end

      puts "#{user.username}: #{user.about}"
      voted_clusters = {}
      voted_clusters.default = 0
      reco_clusters = {}
      reco_clusters.default = 0

      user.frontpage_items.each do |item|
         reco_clusters[item.cluster.id] += 1
      end

      user.likes.each do |item|
         voted_clusters[item.cluster.id] += 1
      end

      puts " -- Recommended Items"
      reco_clusters.sort.each do |cluster, count|
         puts "#{cluster}: #{count}"
      end

      puts " -- Voted on Items"
      voted_clusters.sort.each do |cluster, count|
         puts "#{cluster}: #{count}"
      end
   end

   desc "Print out stats for the current dataset."
   task :stats => :environment do

      pop = User.all.to_a.map {|u| u.likes.count }

      puts " -- User Data"
      puts "Users:                 #{User.all.count}"
      puts "Mean (avg # of votes): #{Math.mean pop}"

      puts " -- Item Data"
      puts "Items: #{Item.all.count}"

      pop = Item.all.to_a.map {|i| i.votes.count }
      variance = Math.variance(pop)
      std_dev = Math.standard_deviation(pop)

      puts " -- Votes Data"
      puts "Population (# of votes):        #{Vote.all.count}"
      puts "Mean (avg # of votes per item): #{Math.mean pop}"

      puts " -- Cluster Data"
      Item.group('cluster_id').count.each do |id, count|
         puts "Cluster #{id}: #{count}"
      end
   end
end
