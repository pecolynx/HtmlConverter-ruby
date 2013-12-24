require 'erb'

class LeftHtmlWriter
  def initialize(template)
    @template = template
  end

  def write(file_path, root)
    content = output(root, 0)
    
    erb = ERB.new(@template)
    
    File.open(file_path, "w") do |x|
      x.write(erb.result(binding))
    end
  end
  
  def output(directory_node, depth)
    result = ''
    
    indent_char = "\t"
    indent1 = indent_char * depth
    indent2 = indent_char * (depth + 1)
    indent3 = indent_char * (depth + 2)
    indent4 = indent_char * (depth + 3)
    indent5 = indent_char * (depth + 4)
    
    result << (indent1 + "<ul>\n")
    result << (indent2 + "<li class=\"jstree-open\">\n")
    result << (indent3 + "<a href=\"#\">" + directory_node.name + "</a>\n")
    
    result << (indent3 + "<ul>\n")
    
    directory_node.sub_directory_list.each { |x|
      result << (output(x, depth + 3))
    }
    
    directory_node.file_list.each { |x|
      path = x.path
      name = x.name
      #puts path
      #puts name
      result << (indent4 + "<li name=\"" + x.path + ".html\">\n")
      result << (indent5 + "<a href=\"#\">" + x.name + "</a>\n")
      result << (indent4 + "</li>\n")
    }
    
    result << (indent3 + "</ul>\n")
    result << (indent2 + "</li>\n")
    result << (indent1 + "</ul>\n")
        
    result
  end
end
