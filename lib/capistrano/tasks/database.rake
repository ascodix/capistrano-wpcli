namespace :wpcli do

  namespace :db do

    desc "Pull the remote database"
    task :pull do
      on roles(:web) do

        within release_path do
          with path: "#{fetch(:path)}:$PATH" do
            execute :wp, "--path=#{fetch(:wp_path)} db export #{fetch(:tmp_dir)}/database.sql"
            execute :gzip, "-f #{fetch(:tmp_dir)}/database.sql"
          end
        end

        download! "#{fetch(:tmp_dir)}/database.sql.gz", "database.sql.gz"

        run_locally do
          timestamp = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{Time.now.hour}-#{Time.now.min}-#{Time.now.sec}"

          system "wp --path=#{fetch(:wp_path)} db export #{fetch(:application)}.#{timestamp}.sql" # backup

          system "7z e database.sql.gz"
          system "wp --path=#{fetch(:wp_path)} db import database.sql"
          system "wp --path=#{fetch(:wp_path)} search-replace #{fetch(:wpcli_remote_url)} #{fetch(:wpcli_local_url)}"

          system "del database.sql.gz"
          system "del database.sql"
        end

      end
    end

    desc "Push the local database"
    task :push => :backup do
      on roles(:web) do
          localFilename = "local-export-database.sql"
          remoteFilename = "remote-export-database.sql"
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
