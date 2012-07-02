module GitHelper
  def git(op, item)
    path = item.respond_to?(:identifier) ? item.send(:identifier) : item
    unless File.file?(path)
      file_name = File.join("./content/", path.slice(0,path.size - 1))
      if File.file?("#{file_name}.html")
        file_name = "#{file_name}.html"
      elsif File.file?("#{file_name}/index.html")
        file_name = "#{file_name}/index.html"
      end
    end

    command = case op
      when :date   then "git log -1 --pretty=\"format:%cd\" \"#{file_name}\""
      when :author then "git log -1 --pretty=\"format:%an\" \"#{file_name}\""
    end
    File.file?(file_name) \
      ? %x{#{command}}.strip \
      : "Item not found '#{file_name}'"
  end
end
