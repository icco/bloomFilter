namespace :data do
   desc "Model an ideal environment."
   task :model => :environment do
      require 'faker'
      require 'json'
      require 'timecop'
      require 'time'
      require 'chronic'

      # Reset db
      Rake::Task["db:reset"].invoke

      # TIME TRAVEL.
      Timecop.travel(Chronic.parse("-1 week"))

      # First build users
      (0..1000).each do |i|
         p = {
            "username" => Faker::Internet.user_name,
            "email" => Faker::Internet.email,
            "password" => "testtest",
         }

         while (!User.valid_username p["username"]) do
            #puts "#{p["username"]} is not valid."
            p["username"] = Faker::Internet.user_name
         end

         while (!User.valid_email p["email"]) do
            #puts "#{p["email"]} is not valid."
            p["email"] = Faker::Internet.email
         end

         u = User.new
         u.email = p["email"]
         u.username = p["username"]
         u.password = p["password"]
         u.save!
         u.errors.each{|e| p e}
         print '.'
      end

      # select 10 topics
      # Store 10 topics in about field.
      topics = (0..100).to_a
      User.find(:all, :order => "created_at").each do |user|
         u_topics = topics.sample(10)
         user.about = u_topics.to_json
         user.save!
      end

      # iterate through a week
      (0..6).each do
         Timecop.travel(Chronic.parse("+1 day"))

         # have users look at posts since they were last online
         # gem 'chronic'
         User.find(:all, :limit => 50, :order => "random()").each do |user|
            posts = user.items.where(":created_at > ?", user.last_sign_in_at)
            # vote on 10 they are interested in that they haven't voted on before

            p posts
         end

      end
      # Have them submit 5 posts they are interested in
      # repeat for the next day. Make sure users are selected randomly.
   end
end
