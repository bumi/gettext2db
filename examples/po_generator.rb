# this is a tmp generator. 
# it is refactored but not tested... 

PATH= RAILS_ROOT + "/po/"
LANGUAGES = []

for lang in LANGUAGES do
  file = PATH + lang + "/SalesKing.po"
  File.open(file,"w+") do |f|
    f << "msgid \"\"\n"
    f << "msgstr \"\"\n"
    f << "\"Project-Id-Version: PACKAGE VERSION\"\n"
    f << "\"POT-Creation-Date: #{Time.now}\"\n"
    f << "\"PO-Revision-Date: #{Time.now}\"\n"
    f << "\"Last-Translator: SalesKing DB\"\n"
    f << "\"Language-Team: SalesKing\"\n"
    f << "\"MIME-Version: 1.0\"\n"
    f << "\"Content-Type: text/plain; charset=UTF-8\"\n"
    f << "\"Content-Transfer-Encoding: 8bit\"\n"
    f << "\"Plural-Forms: nplurals=2; plural=n != 1;\"\n"
    f << "\n\n"
    
    @keys = GettextKey.find(:all, :include => :translations, :order => "created_at ASC")

    @keys.each do |key|
      key.translations.find(:all, :conditions=>{:language=>language}).each do |translation|
        if key.plural? 
          plural = key.plural
          f << "msgid \"#{key.accesskey.downcase}\"\n"
          f << "msgid_plural \"#{plural.accesskey.downcase}\"\n"
          f << "msgstr[0] \"#{translation.text}\"\n" 
          plural.translations.find(:all, :conditions=>{:language=>language}).each do |plural_translation|
            f << "msgstr[1] \"#{plural_translation.text}\"\n"                     
          end
        else
          f << "msgid \"#{key.access_key.downcase}\"\n"
          f << "msgstr \"#{translation.text}\"\n\n"
        end
        #msgid "There is an apple.\n"
        #msgid_plural "There are %{num} apples.\n"
        #msgstr[0] "Da ist ein Apfel.\n"
        #msgstr[1] "Da sind %{num} Äpfel.\n"
      
        f << "\n"
      end
    end
  end
end