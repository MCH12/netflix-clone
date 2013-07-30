class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.references :video_id
      t.references :user_id

      t.integer :position

      t.timestamps
    end
  end
end
