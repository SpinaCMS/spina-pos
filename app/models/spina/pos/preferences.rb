module Spina
  module Pos
    class Preferences < ApplicationRecord
      self.table_name = "spina_pos_preferences"

      belongs_to :user
      
      validates :user_id, presence: true, uniqueness: true
    end
  end
end