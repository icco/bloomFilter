
namespace :data do
   desc "Dump our data for VW."
   task :dump => :environment do
      Item.all.each {|i|
         puts i.title
      }
   end
end
