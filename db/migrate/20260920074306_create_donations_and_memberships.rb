class CreateDonationsAndMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :donations do |t|
      t.references :person, null: true, foreign_key: true
      t.integer :amount_cents, null: false
      t.text :currency, null: false, default: "USD"
      t.boolean :is_recurring, null: false, default: false
      t.text :processor
      t.text :processor_ref
      t.datetime :occurred_at, null: false, default: -> { "now()" }
    end

    create_table :membership_tiers do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :name, null: false
      t.text :billing_period, null: false
      t.integer :price_cents
      t.boolean :income_based, null: false, default: false
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :memberships do |t|
      t.references :person, null: false, foreign_key: true
      t.references :membership_tier, null: false, foreign_key: true
      t.text :status, null: false, default: "active"
      t.datetime :started_at, null: false, default: -> { "now()" }
      t.datetime :expires_at
      t.boolean :auto_renew, null: false, default: true
      t.datetime :cancelled_at
      t.text :stripe_subscription_id
      t.integer :amount_cents, null: false

      t.timestamps
    end

    add_index :memberships, :expires_at

    create_table :membership_payments do |t|
      t.references :membership, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.text :processor
      t.text :processor_ref
      t.datetime :paid_at, null: false, default: -> { "now()" }
    end
  end
end
