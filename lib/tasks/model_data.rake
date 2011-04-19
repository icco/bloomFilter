task :model_data => [:build_users, :submit_posts, :vote]  do
end

task :build_users do
   puts "build users."
end

task :submit_posts do
   puts "submit posts."
end

task :vote do
   puts "voting."
end
