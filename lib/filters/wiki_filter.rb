########################################################################
# WARNING: normal authors are not allowed to change this file.         #
#          all changes will be simply ignored by server                #
########################################################################

# @purpose: A post-processed filter to provide wiki-style when writing
#           article. This filter should be executed after any other
#           filter.
# @author : Anh K. Huynh
#
# @desc   : Replaces [[id<title>]] by a link. The <title> is optional.
#           The `id` may be absolute or relative to `/doc/`. For example
#               /vn/author-guide/   : absolute
#               git/gitconfig       : it's /doc/git/gitconfig/
#           The colon (:) can be used instead of a slash (/)
#
# @return : HTML output
#
class WikiFilter < Nanoc::Filter
  identifier :wiki
  type :text => :text

  def run(content, params={})
    content.gsub(%r{\[\[([^\[\][:space:]]+)( .*)?\]\]}) do |m|
      path, title = $1, $2
      path.gsub!(":", "/")
      path = "#{path.chomp('/')}/"
      path = "/doc/#{path}" unless path[0] == "/"
      title = path.split("/").last if title.nil?
      title.strip!
      "<a href=\"%s\">%s</a>" % [path, title]
    end
  end
end
