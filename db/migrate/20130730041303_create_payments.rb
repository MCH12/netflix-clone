class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user

      t.integer :amount
      t.string :reference_id
    end
  end
end
