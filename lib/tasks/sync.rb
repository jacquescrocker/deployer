namespace :deploy do
  namespace :sync do
    desc "Syncs the configured files from the local machine to the remote machine"
    task :files do
      files = []

      unless respond_to?(:skip_database) and skip_database
        files << "config/database.yml"
      end

      if respond_to?(:sync_files)
        files += sync_files
      end

      files.each do |file|
        if File.exist?(file)
          log "Syncing local file \"#{file}\" to the shared folder (#{appname}/shared/#{file})"
          system "rsync -vr --exclude='.DS_Store' #{file} #{user}@#{application}:#{shared_path}/config/"
        end
      end
    end
  end
end