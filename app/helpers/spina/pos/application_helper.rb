module Spina
  module Pos
    module PosHelper

      def image_variant(image, variant, fallback: nil)
        if image&.file&.attached?
          main_app.url_for(image.file.variant(variant))
        else
          fallback || ""
        end
      rescue
        ""
      end
      
    end
  end
end
