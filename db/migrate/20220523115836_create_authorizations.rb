class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
