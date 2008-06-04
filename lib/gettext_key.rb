class GettextKey < ActiveRecord::Base

  serialize :locations
  serialize :files
  
  validates_uniqueness_of :access_key
  has_many :translations, :class_name => "GettextTranslation", :dependent => :destroy
  
  has_one :plural, :class_name => "GettextKey", :dependent => :destroy, :foreign_key => "singular_id"
  belongs_to :singular, :class_name => "GettextKey", :foreign_key => "singular_id"
  
  before_validation :init_locations_and_files
  
  before_save :make_locations_uniq
  before_save :make_files_uniq
  
  def self.find_or_create_translation(str1,str2,count,options)

    singular = GettextKey.find_or_create_by_access_key(str1)
    singular.locations << options[:url]
    singular.files << options[:file]
    singular.save    
    if str2
      k = GettextKey.find_or_initialize_by_access_key(str2)
      singular.plural = k
      singular.plural.locations << options[:url]
      singular.plural.files << options[:file]
      singular.save && singular.plural.save
    end
    singular.translate_to(GetText.locale.language,count)
  end
  
  def translate_to(language=GetText.locale.language,count=1)
    key = count == 1 ? _singular : _plural
    t = count == 1 ? _singular.translations.find_by_language(language) : _plural.translations.find_by_language(language)
    t.nil? ? key.send(:access_key) : t.text
  end
  
  def singular?
    singular_id.blank?
  end
  
  def plural?
    !singular?
  end
  
  def _singular
    singular? ? self : singular
  end
  
  def _plural
    plural? ? self : plural
  end
  
  private
  
    def init_locations_and_files
      self.files ||= []
      self.locations ||= []
    end
    def make_locations_uniq
      self.locations = self.locations.uniq
    end
    def make_files_uniq
      self.files = self.files.uniq
    end
end