class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :title, null: false
      t.text :description
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.boolean :is_multi_day, null: false, default: false
      t.text :virtual_url
      t.text :recurrence_rule

      t.timestamps
    end

    create_table :event_locations do |t|
      t.references :event, null: false, foreign_key: true
      t.text :name, null: false
      t.text :address
      t.st_point :geom, geographic: true

      t.timestamps
    end

    create_table :event_shifts do |t|
      t.references :event, null: false, foreign_key: true
      t.references :event_location, null: true, foreign_key: true
      t.text :title
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.text :role
      t.integer :capacity
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :event_shifts, [:starts_at, :ends_at]

    create_table :shift_signups do |t|
      t.references :event_shift, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.text :role
      t.text :status, null: false, default: "confirmed"

      t.timestamps
    end

    add_index :shift_signups, [:event_shift_id, :person_id], unique: true, name: "idx_signups_shift_person"

    create_table :event_rsvps do |t|
      t.references :event, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.text :status, null: false
      t.boolean :attended

      t.timestamps
    end

    add_index :event_rsvps, [:event_id, :person_id], unique: true, name: "idx_rsvps_event_person"
  end
end
