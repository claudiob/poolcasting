class CreateEvaluations < ActiveRecord::Migration
  def self.up
    create_table :evaluations do |t|
      t.references :association
      t.float :degree
      t.datetime :created_at
    end
    add_index :evaluations, :association_id
  end

  def self.down
    drop_table :evaluations
  end
end
