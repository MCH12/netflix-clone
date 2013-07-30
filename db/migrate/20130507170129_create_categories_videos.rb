class CreateCategoriesVideos < ActiveRecord::Migration
  def change
    create_table :categories_videos, id: false do |t|
      t.references :category
      t.references :video
    end
    
    add_index :categories_videos, [:category_id, :video_id], unique: true
  end
end
