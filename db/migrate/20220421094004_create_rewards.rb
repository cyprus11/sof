class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
