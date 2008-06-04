class Gettext2Db < ActiveRecord::Migration
  def self.up
    create_table :gettext_keys do |t|
      t.integer :singular_id
      t.text :locations, :files
      t.string :access_key
      
      t.timestamps
    end
    
    create_table :gettext_translations do |t|
      t.integer :gettext_key_id
      t.text :text, :comment
      t.string :language
      
      t.timestamps
    end
  end

  def self.down
    drop_table :gettext_translations
    drop_table :gettext_keys
  end
end
