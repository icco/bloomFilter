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

      (0..5).each {|i| Cluster.rebuild }
   end
end
