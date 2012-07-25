########################################################################
# WARNING: normal authors are not allowed to change this file.         #
#          all changes will be simply ignored by server                #
########################################################################

require 'cgi'

module GitHelper

  def item_to_file(item)
    path = item.respond_to?(:identifier) ? item.send(:identifier) : item
    if File.file?(path)
      file_name = path
    else
      file_name = File.join("./content/", path.slice(0,path.size - 1))
      ext = %w{.html .rb /index.html /index.rb}.detect do |e|
        File.file?("#{file_name}#{e}")
      end
      file_name = ext ? "#{file_name}#{ext}" : nil
    end
    file_name = File.realpath(file_name) if file_name and File.symlink?(file_name)
    file_name
  end

  # @purpose: Provide git information of an item
  # @author:  Anh K. Huynh
  # @syntax:
  #   git(:date, item)
  #   git(:author, item)
  #
  # @example: see in layouts/default.html
  #
  def git(op, item)
    file_name = item_to_file(item)

    command = case op
      when :date        then "git log -1 --pretty=\"format:%cd\" \"#{file_name}\""
      when :author      then "git log -1 --pretty=\"format:%an\" \"#{file_name}\""
      when :last_update then "git log -1 --pretty=\"format:last updated by %an @ %cd\" \"#{file_name}\""
      when :stat        then
                              <<-EOF
                                git log --pretty="format:%an" "#{file_name}" | sort    | wc -l ;
                                echo ' commit(s) ';
                                git log --pretty="format:%an" "#{file_name}" | sort -u | wc -l ;
                                echo ' author(s)';
                              EOF
      else nil
    end

    command and File.file?(file_name) \
      ? %x{#{command}}.strip.gsub("\n", "") \
      : "Couldn't fetch information for item '#{path}'"
  end

  # @purpose: Print last 50 changes in git log
  # @author : Anh K. Huynh
  # @date   : 2012 July 19th
  # @syntax :
  #   recent_changs(number_of_changes)
  #
  def recent_changes(num = 30)
    github = "https://github.com/archlinuxvn/home/commit/"
    command = "git log --pretty=\"format:%h:%an:%s\" -#{num}"

    ret = ["<ol>"]

    current_author = nil
    ret << %x{#{command}}.split(/\n+/).map do |s|
      splitted = CGI.escapeHTML(s.strip).split(":")
      hash = splitted.first
      if hash.match(/^[0-9a-z]+$/)
        author, subject = splitted[1], splitted[2, splitted.size].join(":")
        d_author = (author == current_author ? "" : "-- <strong>#{author}</strong>")
        current_author = author
        "<li><a href=\"%s%s\">%s</a> %s %s</li>" % [github, hash, hash, subject, d_author]
      else
        current_author = nil
        "<li>#{s}</li>"
      end
    end

    ret << ["</ol>"]
    ret.join("\n")
  end

  def recent_posts(num = 30)
    ret = ["<ol>"]
    all_items = @items.find_all.sort_by do |i|
      if file_name = item_to_file(i)
        File.mtime(file_name)
      else
        Time.new(0)
      end
    end.reverse

    all_items.slice(0,num).each do |p|
      if gs = p.identifier.match(%r{^/blog/([^/]+)/.+})
        ret << "<li>%s - %s</li>" % [gs[1], link_to(p[:title], p.identifier)]
      elsif gs = p.identifier.match(%r{^/faq/.+})
        ret << "<li>faq - %s</li>" % [link_to(p[:title], p.identifier)]
      elsif gs = p.identifier.match(%r{^/vn/([^/]+)/})
        page = gs[1]
        if %w{author-guide bot irc news}.include?(page)
          ret << "<li>home - %s</li>" % [link_to(p[:title], p.identifier)]
        end
      end
    end
    ret << ["</ol>"]
    ret.join("\n")
  end
end
