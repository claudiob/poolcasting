class Identification < ActiveRecord::Base
  belongs_to  :item, :polymorphic => true
  belongs_to  :identifier, :polymorphic => true

end
