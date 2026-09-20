class CreatePagesAndForms < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :slug, null: false
      t.text :title
      t.jsonb :content_json, null: false
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :pages, [:organization_id, :slug], unique: true

    create_table :form_submissions do |t|
      t.references :page, null: false, foreign_key: true
      t.references :person, null: true, foreign_key: true
      t.jsonb :answers, null: false
      t.datetime :submitted_at, null: false, default: -> { "now()" }
    end

    execute "ALTER TABLE pages ALTER COLUMN content_json SET DEFAULT '{}'::jsonb"
  end
end
