namespace :load do

  desc "Load configuration"
  task :defaults do

    # L'url sous laquelle l'installation wordpress est disponible sur le serveur local
    # The url under which wordpress installation is available on the local server
    set :wpcli_local_url, "http://example.dev"

    # L'url sous laquelle l'installation wordpress est disponible sur le serveur distant
    # The url under which wordpress installation is available on the remote server
    set :wpcli_remote_url, "http://example.com"

    # Le répertoire temporaire local qui est lu et accessible en écriture
    # A local temp dir which is read and writeable
    set :wpcli_remote_tmp_dir, "/tmp"

    # Le répertoire des fichiers de sauvegarde
    # The backup files directory
    set :wpcli_local_backup_dir, "config/backup"

    # La date de maintenant
    # The date of now
    set :wpcli_now, -> {"#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}"}

    # Le nom du fichier sql de sauvagarde de la base locale
    # The name of the wildfire sql file from the local database
    set :wpcli_backup_local_db_file, -> {"backup.local.#{fetch(:wpcli_now)}.sql"}

    # Le nom du fichier sql de sauvagarde de la base distante
    # The name of the wildfire sql file from the remote database
    set :wpcli_backup_remote_db_file, -> {"backup.remote.#{fetch(:wpcli_now)}.sql.gz"}

  end

end