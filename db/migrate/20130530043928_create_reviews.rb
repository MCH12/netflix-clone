class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :video

      t.text :body
      t.integer :rating

      t.timestamps
    end
  end
end
