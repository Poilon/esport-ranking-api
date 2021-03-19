class UuidPgExtensions < ActiveRecord::Migration[5.2]

  def change
    execute 'CREATE EXTENSION "uuid-ossp" SCHEMA pg_catalog;'
  end

end
