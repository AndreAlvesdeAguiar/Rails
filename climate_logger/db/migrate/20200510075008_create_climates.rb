class CreateClimates < ActiveRecord::Migration[6.0]
  def change
    create_table :climates do |t|
      t.string :log_message
      t.integer :temperature
      t.integer :fan_position

      t.timestamps
    end
  end
end
