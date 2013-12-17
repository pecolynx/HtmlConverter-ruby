require 'erb'

class RightHtmlWriter
  def initialize(template)
    @template = template
  end

  def write(brush, src_file_path, dst_file_path, depth)
    erb = ERB.new(@template)
    title = File.basename(src_file_path)
    path = File.join("", "")

    File.open(dst_file_path, "w") do |x|
      x.write(erb.result(binding))
    end
  end
end
