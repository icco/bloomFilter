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
      Timecop.travel(Chronic.parse("last week"))

      topics = (0..100).to_a

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

         u = User.new p
         # select 10 topics
         # Store 10 topics in about field.
         u.about = topics.sample(10).sort.to_json
         u.save!
         u.errors.each{|e| p e}
         print '.'
      end

      # iterate through a week
      (1..7).each do |i|
         puts "\nDay #{i} - #{Time.now}"

         # have users look at posts since they were last online
         User.find(:all, :limit => 50, :order => "random()").each do |user|
            topics = JSON.parse(user.about)

            topics.sample(2).each do |topic|
               uuid = (0..10).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join
               params = {
                  :user_id => user.id,
                  :url => "http://#{topic}.com/#{uuid}",
                  :title => "User: #{user.id}, Topic: #{topic}"
               }

               i = Item.new params
               i.save
               print 'i'
            end

            # vote on 10 they are interested in that they haven't voted on before
            posts = Item.where("user_id != ?", user.id).order("created_at DESC")
            posts = posts.keep_if {|post| !post.user_voted? user }

            voteCount = 0
            posts.each {|post|
               if voteCount <= 15
                  topics.each {|t|
                     if !%r{http://#{t}\.com/.*}.match(post.url).nil?
                        post.vote 'up', user
                        print 'v'
                        voteCount += 1
                     end
                  }
               end
            }
         end

         Timecop.travel(Chronic.parse("tomorrow"))
      end

      puts ""

      # Print stats.
      Rake::Task["data:stats"].invoke
   end
end
