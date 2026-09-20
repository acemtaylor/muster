class CreateSavedLists < ActiveRecord::Migration[8.1]
  def change
    create_table :list_folders do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :name, null: false

      t.timestamps
    end

    create_table :saved_lists do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :folder, null: true, foreign_key: { to_table: :list_folders }
      t.text :name, null: false
      t.text :subject_type, null: false, default: "person"
      t.jsonb :filter_json, null: false
      t.boolean :is_dynamic, null: false, default: true
      t.references :created_by, null: true, foreign_key: { to_table: :team_members }

      t.timestamps
    end

    create_table :saved_list_memberships, id: false do |t|
      t.references :saved_list, null: false, foreign_key: true
      t.text :subject_type, null: false
      t.bigint :subject_id, null: false
    end

    add_index :saved_list_memberships, [:saved_list_id, :subject_type, :subject_id],
              unique: true, name: "idx_slm_primary"
    add_index :saved_list_memberships, [:subject_type, :subject_id], name: "idx_slm_subject"
  end
end
