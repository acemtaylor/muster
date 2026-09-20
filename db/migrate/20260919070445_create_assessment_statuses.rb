class CreateAssessmentStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :assessment_statuses do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :key, null: false
      t.text :label, null: false
      t.text :color
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :assessment_statuses, [ :organization_id, :key ], unique: true

    create_table :assessment_status_changes do |t|
      t.references :person, null: false, foreign_key: true
      t.references :changed_by, null: true, foreign_key: { to_table: :team_members }
      t.text :old_status
      t.text :new_status
      t.datetime :changed_at, null: false, default: -> { "now()" }
    end
  end
end
