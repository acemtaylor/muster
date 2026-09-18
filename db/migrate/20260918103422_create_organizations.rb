class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.bigint  :parent_id
      t.text    :name, null: false
      t.text    :slug, null: false
      t.text    :kind, null: false, default: "organization"
      t.column  :path, :ltree
      t.integer :depth, null: false, default: 0
      t.text    :country
      t.text    :timezone, default: "UTC"
      t.jsonb   :settings

      t.timestamps
    end

    add_index :organizations, :slug, unique: true
    add_index :organizations, :parent_id
    add_index :organizations, :path, using: :gist
    add_foreign_key :organizations, :organizations, column: :parent_id

    execute "ALTER TABLE organizations ALTER COLUMN settings SET DEFAULT '{}'::jsonb"
  end
end
