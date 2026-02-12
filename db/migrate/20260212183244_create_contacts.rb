class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.references :user, null: false, foreign_key: true
      # το friend_id αναφέρεται στον πίνακα users
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'pending' # Ξεκινάει πάντα ως pending
      t.timestamps
    end
    
    # Για να μην μπορείς να στείλεις 2 φορές αίτημα στον ίδιο
    add_index :contacts, [:user_id, :friend_id], unique: true
  end
end