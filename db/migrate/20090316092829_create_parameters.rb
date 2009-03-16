class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.float :alpha2, :default => 0.3
      t.float :alpha3, :default => 0.2
      t.float :beta,   :default => 0.8
      t.float :gamma,  :default => 0
      t.float :phi2,   :default => 0.3
      t.float :phi3,   :default => 0.2
      t.datetime :created_at
    end
    Parameter.create
  end

  def self.down
    drop_table :parameters
  end
end