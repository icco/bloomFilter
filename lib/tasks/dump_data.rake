namespace :data do
   desc "Dump our data for VW."
   task :dump => :environment do
      user = User.limit(1).order("random()").first

      user.likes.each do |item|
         item.cluster = Cluster.closest(item)
         item.save
      end

      user.frontpage_items.each do |item|
         item.cluster = Cluster.closest(item)
         item.save
      end

      (1..5).each {|i| Cluster.rebuild }

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

      [reco_clusters, voted_clusters].each do |hash|
         puts "hash --- "
         hash.each_pair do |cluster, count|
            puts "#{cluster}: #{count}"
         end
      end
   end

   desc "Print out stats for the current dataset."
   task :stats => :environment do
      pop = Item.all.to_a.map {|i| i.votes.count }
      variance = Math.variance(pop)
      std_dev = Math.standard_deviation(pop)

      puts " -- Votes Data"
      puts "Population (# of votes): #{pop.count}"
      puts "Mean (avg # of votes):   #{Math.mean pop}"
      puts "Variance:                #{variance}"
      puts "Standard Deviation:      #{std_dev}"
   end
end
