namespace :wpcli do

  namespace :db do

    desc "Push the local database"
    task :push => :backup do
      on roles(:web) do
          localFilename = "export-database.sql"
          remoteFilename = "export-database.sql"
          system "wp search-replace #{fetch(:wpcli_local_url)} #{fetch(:wpcli_remote_url)} --export=#{localFilename}"
          upload! localFilename, "#{fetch(:wpcli_remote_tmp_dir)}/#{remoteFilename}"
          execute "cd '#{release_path}' && wp db import #{fetch(:wpcli_remote_tmp_dir)}/#{remoteFilename}"
          execute :rm, "#{fetch(:wpcli_remote_tmp_dir)}/#{remoteFilename}"
      end
    end

    desc "Backup of the remote database"
    task :backup => :clean_backup do
      on roles(:web) do
        within release_path do
          # Backup remote database
          execute "cd '#{release_path}' && wp db export - | gzip > #{fetch(:wpcli_remote_tmp_dir)}/#{fetch(:wpcli_backup_remote_db_file)}"
          download! "#{fetch(:wpcli_remote_tmp_dir)}/#{fetch(:wpcli_backup_remote_db_file)}", "#{fetch(:wpcli_local_backup_dir)}/#{fetch(:wpcli_backup_remote_db_file)}"
          execute :rm, "#{fetch(:wpcli_remote_tmp_dir)}/#{fetch(:wpcli_backup_remote_db_file)}"

          # Backup locale database
          system "wp db export #{fetch(:wpcli_local_backup_dir)}/#{fetch(:wpcli_backup_local_db_file)}"
        end
      end
    end

    desc "Clean backup local directory"
    task :clean_backup do

    end

  end

end
