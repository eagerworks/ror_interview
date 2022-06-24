class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.references :team, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :description
      t.integer :total

      t.timestamps
    end
  end
end
