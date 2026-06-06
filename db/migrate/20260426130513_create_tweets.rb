class CreateTweets < ActiveRecord::Migration[7.2]
  def change
    create_table :tweets do |t|
      t.string :name
      t.text :body
      t.datetime :datetime
      t.integer :user_id

      t.timestamps
    end
  end
end
