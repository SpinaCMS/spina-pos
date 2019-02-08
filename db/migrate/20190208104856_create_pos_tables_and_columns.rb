class CreatePosTablesAndColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :spina_pos_cash_adjustments do |t|
      t.decimal :amount, precision: 8, scale: 2, default: '0.0', null: false
      t.integer :shift_id, null: false
      t.timestamps
    end

    create_table :spina_pos_shifts do |t|
      t.integer :user_id, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime
      t.decimal :opening_balance, precision: 8, scale: 2, default: "0.0", null: false
      t.decimal :cash_counted, precision: 8, scale: 2, default: "0.0", null: false
      t.decimal :cash_left, precision: 8, scale: 2, default: "0.0", null: false
      t.decimal :cash_expected, precision: 8, scale: 2, default: "0.0", null: false
      t.text :note
      t.timestamps
    end

    create_table :spina_pos_preferences do |t|
      t.integer :user_id
      t.string :printer_ip
      t.timestamps
      t.boolean :ssl, default: false, null: false
    end

    add_column :spina_shop_orders, :total_cash, :decimal, precision: 8, scale: 2, default: "0.0", null: false
    add_column :spina_shop_orders, :rounding_difference, :decimal, precision: 8, scale: 2, default: "0.0", null: false
    add_column :spina_shop_orders, :shift_id, :integer
    
    add_index :spina_shop_orders, :shift_id
  end
end
