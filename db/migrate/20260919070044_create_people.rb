class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.references :organization, null: false, foreign_key: true

      t.text :first_name
      t.text :last_name
      t.text :alternate_name
      t.citext :email
      t.text :phone_number
      t.text :secondary_phone
      t.date :date_of_birth

      t.text :address_1
      t.text :address_2
      t.text :city
      t.text :state
      t.text :postal_code
      t.text :country

      t.st_point :geom, geographic: true

      t.text :preferred_language, default: "en"
      t.text :assessment
      t.text :created_by_method

      t.timestamps
    end

    add_index :people, :phone_number
    add_index :people, :email
    add_index :people, [ :organization_id, :phone_number ], name: "idx_people_org_phone"
    add_index :people, [ :organization_id, :email ], name: "idx_people_org_email"

    execute <<-SQL
      CREATE INDEX idx_people_search ON people USING GIN (
        to_tsvector('english', coalesce(first_name,'') || ' ' || coalesce(last_name,'') || ' ' || coalesce(email,''))
      );
    SQL
  end
end
