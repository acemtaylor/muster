class EnableExtensions < ActiveRecord::Migration[7.2]
  def change
    enable_extension "postgis"
    enable_extension "ltree"
    enable_extension "citext"
    enable_extension "pg_trgm"
  end
end
