namespace :load do

  task :defaults do

    # The url under which the wordpress installation is
    # available on the remote server
    set :wpcli_remote_url, "http://example.com"

    # The url under which the wordpress installation is
    # available on the local server
    set :wpcli_local_url, "http://example.dev"

    # A local temp dir which is read and writeable
    set :local_tmp_dir, "/tmp"

    # Use current time for annotating the backup file
    set :current_time, -> { Time.now.strftime("%Y%m%d%H%M") }

    # Boolean to determine wether the database should be backed up or not
    set :wpcli_backup_db, false

    # Set the location of the db backup files. This is relative to the local project root path.
    set :wpcli_local_db_backup_dir, "config/backup"

    # Temporary db dumps path
    set :wpcli_remote_db_file, -> {"#{fetch(:tmp_dir)}/wpcli_database.sql.gz"}
    set :wpcli_local_db_file, -> {"#{fetch(:local_tmp_dir)}/wpcli_database.sql.gz"}

    # Backup file filename
    set :wpcli_local_db_backup_filename, -> {"db_#{fetch(:stage)}_#{fetch(:current_time)}.sql.gz"}

  end

end

namespace :wpcli do

  namespace :db do
    desc "Push the local database"
    task :push do
      on roles(:web) do
        run_locally do
          system "wp db export database.sql"
          system "wp search-replace http://www.wp-knowledge-base.local http://www.blog.stephane-albuisson.com --export=database-prod.sql"
          puts "ici"
        end

        #upload! "database.sql", "#{fetch(:tmp_dir)}/database.sql"

        run_locally do
          puts "ici"
          #execute :rm, "database.sql"
        end

        within release_path do
          with path: "#{fetch(:path)}:$PATH" do
            puts "ici"
            #execute :mysql, "-u #{fetch(:wpdb)[fetch(:stage)][:user]} -p\"#{fetch(:wpdb)[fetch(:stage)][:password]}\" -h #{fetch(:wpdb)[fetch(:stage)][:host]} #{fetch(:wpdb)[fetch(:stage)][:name]} < #{fetch(:tmp_dir)}/database.sql"
            #execute :rm, "#{fetch(:tmp_dir)}/database.sql"
          end
        end
      end
    end
  end

end
