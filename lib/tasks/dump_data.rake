namespace :data do
   desc "Dump our data for VW."
   task :dump => :environment do
      Item.all.each {|i|
         puts i.title
      }
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
