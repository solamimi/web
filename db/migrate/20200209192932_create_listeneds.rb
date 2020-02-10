class CreateListeneds < ActiveRecord::Migration[5.2]
  def change
    create_table :listeneds do |t|
      t.datetime :listen_at
      t.integer :user_id
      t.string :listen_words
      t.string :listen_origin
      t.integer :value

      t.integer :lock_version, default: 0, null: false
      t.integer :created_by
      t.integer :updated_by
      t.integer :deleted_by

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
