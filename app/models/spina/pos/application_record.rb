module Spina
  module Pos
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
