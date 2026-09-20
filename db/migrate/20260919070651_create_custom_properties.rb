class CreateCustomProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :custom_property_definitions do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :key, null: false
      t.text :label, null: false
      t.text :data_type, null: false
      t.jsonb :options
      t.text :group_name
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :custom_property_definitions, [ :organization_id, :key ], unique: true

    create_table :custom_property_values do |t|
      t.references :person, null: false, foreign_key: true
      t.references :definition, null: false, foreign_key: { to_table: :custom_property_definitions }
      t.jsonb :value
    end

    add_index :custom_property_values, [ :person_id, :definition_id ], unique: true, name: "idx_cpv_person_definition"
    add_index :custom_property_values, :value, using: :gin

    execute "ALTER TABLE custom_property_definitions ALTER COLUMN options SET DEFAULT '[]'::jsonb"
  end
end
