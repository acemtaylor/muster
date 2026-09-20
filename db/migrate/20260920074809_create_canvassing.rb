class CreateCanvassing < ActiveRecord::Migration[8.1]
  def change
    create_table :turfs do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :name, null: false
      t.st_polygon :boundary, geographic: true, null: false

      t.timestamps
    end

    create_table :canvasses do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :name, null: false
      t.text :script

      t.timestamps
    end

    create_table :canvass_attempts do |t|
      t.references :canvass, null: false, foreign_key: true
      t.references :turf, null: true, foreign_key: true
      t.references :person, null: true, foreign_key: true
      t.references :canvasser, null: true, foreign_key: { to_table: :team_members }
      t.text :knock_result
      t.datetime :occurred_at, null: false, default: -> { "now()" }
    end

  end
end
