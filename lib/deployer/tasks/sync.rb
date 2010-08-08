namespace :deploy do
  namespace :sync do
    desc "Syncs the configured files from the local machine to the remote machine"
    task :files do
      files = []

      unless exists?(:skip_database) and skip_database
        files << "config/database.yml"
      end

      if exists?(:sync_files)
        files += sync_files
      end

      files.each do |file|
        if File.exist?(file)
          path_parts = file.split('/')
          file = path_parts.pop
          if path_parts.empty?
            path = ''
          else
            path = path_parts.join('/') + '/'
          end
          
          log "Syncing local file \"#{path + file}\" to the shared folder (#{appname}/shared/#{path + file})"
          system "rsync -vr --exclude='.DS_Store' #{path + file} #{user}@#{application}:#{shared_path}/#{path}"
        end
      end
    end
  end
end