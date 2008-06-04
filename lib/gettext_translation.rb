class GettextTranslation < ActiveRecord::Base
  belongs_to :key, :class_name => "GettextKey"
end
