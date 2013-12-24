require 'erb'
require 'cgi'

class RightHtmlWriter
  def initialize(template)
    @template = template
  end

  def write(brush, src_file_path, dst_file_path, depth)
    content = ""
    File.open(src_file_path, "r:BOM|UTF-8") do |x|
      content = CGI.escapeHTML(x.read)
    end

    erb = ERB.new(@template)
    title = File.basename(src_file_path)
    path = "../" * depth
    style = brush.style
    javascript = brush.javascript

    File.open(dst_file_path, "w") do |x|
      x.write(erb.result(binding))
    end
  end
end
