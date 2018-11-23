namespace :wpcli do

  namespace :db do

    timestamp = "#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}"

    desc "Pull the remote database"
    task :pull => ["create_local_directory", "remote_backup", "local_backup", "local_import", "clean"] do

    end

    desc "Push the local database"
    task :push => ["create_local_directory", "local_backup", "remote_backup", "remote_import", "clean"] do

    end

    desc "Create directory local backup"
    task :create_local_directory do
      backupPath = "#{fetch(:wpcli_local_backup_dir)}"

      Dir.mkdir(backupPath) unless Dir.exists?(backupPath)
      Dir.mkdir(backupPath + "/remote") unless Dir.exists?(backupPath + "/remote")
      Dir.mkdir(backupPath + "/local") unless Dir.exists?(backupPath + "/local")
    end

    desc "Backup the remote database"
    task :remote_backup do
      on roles(:web) do
        within release_path do
          with path: "#{fetch(:path)}:$PATH" do
            execute :wp, "--path=#{fetch(:wp_path)} db export #{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql"
            execute :gzip, "-f #{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql"
          end
        end

        download! "#{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql.gz", "#{fetch(:wpcli_local_backup_dir)}/remote/#{fetch(:application)}.#{timestamp}.sql.gz"
      end
    end

    desc "Backup the local database"
    task :local_backup do
      on roles(:web) do
        run_locally do
          system "wp --path=#{fetch(:wp_path)} db export #{fetch(:wpcli_local_backup_dir)}/local/#{fetch(:application)}.#{timestamp}.sql"
        end
      end
    end

    desc "Import the local database"
    task :local_import do
      on roles(:web) do
          run_locally do
            system "7z e #{fetch(:wpcli_local_backup_dir)}/remote/#{fetch(:application)}.#{timestamp}.sql.gz -o#{fetch(:wpcli_local_backup_dir)}/remote"
            system "wp --path=#{fetch(:wp_path)} db import #{fetch(:wpcli_local_backup_dir)}/remote/#{fetch(:application)}.#{timestamp}.sql"
            system "wp --path=#{fetch(:wp_path)} search-replace #{fetch(:wpcli_remote_url)} #{fetch(:wpcli_local_url)}"
          end
        end
    end

    desc "Import the remote database"
    task :remote_import do
      on roles(:web) do
        run_locally do
          system "7z a #{fetch(:wpcli_local_backup_dir)}/local/#{fetch(:application)}.#{timestamp}.sql.gz #{fetch(:wpcli_local_backup_dir)}/local/#{fetch(:application)}.#{timestamp}.sql"
        end

        upload! "#{fetch(:wpcli_local_backup_dir)}/local/#{fetch(:application)}.#{timestamp}.sql.gz", "#{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql.gz"

        within release_path do
          with path: "#{fetch(:path)}:$PATH" do
            execute :gunzip, "-f #{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql.gz"
            execute :wp, "--path=#{fetch(:wp_path)} db import #{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql"
            execute :wp, "--path=#{fetch(:wp_path)} search-replace #{fetch(:wpcli_local_url)} #{fetch(:wpcli_remote_url)}"
          end
        end
      end
    end

    desc "Clean the tmp file"
    task :clean do
      # On supprime le fichier de backup distant sql local
      if File.exist?("#{fetch(:wpcli_local_backup_dir)}/remote/#{fetch(:application)}.#{timestamp}.sql")
        File.delete("#{fetch(:wpcli_local_backup_dir)}/remote/#{fetch(:application)}.#{timestamp}.sql")
      end

      # On supprime le fichier de backup local sql.gz local
      if File.exist?("#{fetch(:wpcli_local_backup_dir)}/local/#{fetch(:application)}.#{timestamp}.sql.gz")
        File.delete("#{fetch(:wpcli_local_backup_dir)}/local/#{fetch(:application)}.#{timestamp}.sql.gz")
      end

      # On supprime le fichier sql.gz et .sql distant sur le serveur
      on roles(:web) do
        within release_path do
          if remote_file_exists?("#{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql.gz")
            execute "rm #{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql.gz"
          end

          if remote_file_exists?("#{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql")
            execute "rm #{fetch(:tmp_dir)}/#{fetch(:application)}.#{timestamp}.sql"
          end
        end
      end
    end

    def remote_file_exists?(full_path)
      'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
    end

  end
end
