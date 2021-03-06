namespace :radiant do
  namespace :extensions do
    namespace :staff_profiles do
      
      desc "Runs migrations for the Staff Profiles extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          StaffProfilesExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          StaffProfilesExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Staff Profiles extension to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[StaffProfilesExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(StaffProfilesExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
