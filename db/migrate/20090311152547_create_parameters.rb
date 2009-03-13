class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.float :alpha
      t.float :beta
      t.float :gamma
      t.integer :delta
      t.float :phi
      t.float :psi
      t.datetime :created_at
    end
    Parameter.create(:alpha => 0.8, :beta => 0.8, :gamma => 1, 
                     :delta => 3, :phi => 0.5, :psi => 0.5)
  end

  def self.down
    drop_table :parameters
  end
end
