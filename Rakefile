require_relative './app'
require 'sinatra/activerecord/rake'

namespace :db do
  desc "Create a new user"
  task :create_user, [:username, :password] do |t, args|
    if args[:username].nil? || args[:password].nil?
      puts "Usage: rake db:create_user[username,password]"
      exit
    end

    # Load the application environment
    require_relative './app'

    user = User.new(username: args[:username], password: args[:password])

    if user.save
      puts "User '#{user.username}' created successfully."
    else
      puts "Error creating user: #{user.errors.full_messages.join(", ")}"
    end
  end

  desc "Change a user's password"
  task :change_password, [:username, :password] do |t, args|
    if args[:username].nil? || args[:password].nil?
      puts "Usage: rake db:change_password[username,new_password]"
      exit
    end

    # Load the application environment
    require_relative './app'

    user = User.find_by(username: args[:username])

    if user.nil?
      puts "User '#{args[:username]}' not found."
      exit
    end

    if user.update(password: args[:password])
      puts "Password for user '#{user.username}' changed successfully."
    else
      puts "Error changing password: #{user.errors.full_messages.join(", ")}"
    end
  end
end

namespace :setup do
  desc "Create .env file with a new SESSION_SECRET if it doesn't exist"
  task :env do
    if File.exist?('.env')
      puts ".env file already exists. Skipping."
    else
      require 'securerandom'
      secret = SecureRandom.hex(64)
      File.write('.env', "SESSION_SECRET=#{secret}\n")
      puts "Created .env file with a new SESSION_SECRET."
    end
  end
end
