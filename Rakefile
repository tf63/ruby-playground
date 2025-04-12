desc "Check Ruby and other files"
task :check do
  sh "bundle exec standardrb"
  sh "npm run check"
end

desc "Format Ruby and other files"
task :format do
  sh "bundle exec standardrb --fix"
  sh "npm run format"
end
