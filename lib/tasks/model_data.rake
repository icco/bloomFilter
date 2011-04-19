namespace :data do

   desc "Model an ideal environment."
   task :model => :environment do
      require 'faker'

      # Reset db
      Rake::Task["db:reset"].invoke

      # First build users
      (0..1000).each do
         p = {
            "username" => Faker::Internet.user_name,
            "email" => Faker::Internet.email,
            "password" => "testtest",
         }

         while (!User.valid_username p["username"]) do
            puts "#{p["username"]} is not valid."
            p["username"] = Faker::Internet.user_name
         end

         while (!User.valid_email p["email"]) do
            puts "#{p["email"]} is not valid."
            p["email"] = Faker::Internet.email
         end

         u = User.new
         u.email = p["email"]
         u.username = p["username"]
         u.password = p["password"]
         u.save!
         u.errors.each{|e| p e}
      end

      # Then have them post and vote
      # 5 posts a day, 10 votes a day
   end
end
