class CreateAutomations < ActiveRecord::Migration[8.1]
  def change
    create_table :automations do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :name, null: false
      t.text :trigger_type, null: false
      t.jsonb :trigger_config
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :automation_steps do |t|
      t.references :automation, null: false, foreign_key: true
      t.integer :position, null: false
      t.text :step_type, null: false
      t.jsonb :config
    end

    create_table :follow_up_tasks do |t|
      t.references :person, null: false, foreign_key: true
      t.references :assigned_to, null: true, foreign_key: { to_table: :team_members }
      t.text :note
      t.datetime :due_at
      t.datetime :completed_at

      t.timestamps
    end

    execute "ALTER TABLE automations ALTER COLUMN trigger_config SET DEFAULT '{}'::jsonb"
    execute "ALTER TABLE automation_steps ALTER COLUMN config SET DEFAULT '{}'::jsonb"
  end
end
