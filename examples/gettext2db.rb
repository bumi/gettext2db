#remove __END__ to activate gettext2db
__END__
#put this somehow into the plugin. bit it needs to be loaded very late!
module GetText
  def db_gettext(str1,str2=nil,count=1,options={})
    options[:uri] ||= respond_to?("request") ? request.request_uri : nil
  
    file,line,method = parse_caller(caller(1).first)
    #otherwise method is _ or any gettext method
    method = parse_caller(caller(2).first)
  
    options[:file] ||=  "#{file}::#{line}::in::#{method}"
 	  ::GettextKey.find_or_create_translation(str1,str2,count,options)
  end

  def method_name
    parse_caller(caller(1).first).last
  end

  def parse_caller(at)
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
  	file = Regexp.last_match[1]
  	line = Regexp.last_match[2].to_i
  	method = Regexp.last_match[3]
  	[file, line, method]
    end
  end

  def _(str); db_gettext(str); end
  def gettext(str);db_gettext(str); end
  def s_(str); db_gettext(str); end
  def N_(str); db_gettext(str); end
  def n_(str1, str2,count); db_gettext(str1,str2,count); end
  def ngettext(str1,str2,count); db_gettext(str1,str2,count); end

end
