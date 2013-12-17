require 'erb'

class LeftHtmlWriter
  def initialize(template)
    @template = template
  end

  def write(file_path, title)
    erb = ERB.new(@template)

    File.open(file_path, "w") do |x|
      x.write(erb.result(binding))
    end
  end
end
