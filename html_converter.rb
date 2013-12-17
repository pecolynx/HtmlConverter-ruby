require "./brush"
require "./node"
require "./directory_reader"
require './index_html_writer'
require './left_html_writer'
require './right_html_writer'
require 'fileutils'

puts 'ruby'
puts 'a'
xml = Brush.new("x", "y")
puts xml.javaScript
puts xml.style

brush_dictionary = {}
brush_dictionary["as3"] = Brush.new("shBrushAS3.js", "as3")
brush_dictionary["bash"] = Brush.new("shBrushBash.js", "bash")
brush_dictionary["coldfusion"] = Brush.new("shBrushColdFusion.js", "coldfusion")
brush_dictionary["cpp"] = Brush.new("shBrushCpp.js", "cpp")
brush_dictionary["csharp"] = Brush.new("shBrushCSharp.js", "csharp")
brush_dictionary["css"] = Brush.new("shBrushCss.js", "css")
brush_dictionary["delphi"] = Brush.new("shBrushDelphi.js", "delphi")
brush_dictionary["diff"] = Brush.new("shBrushDiff.js", "diff")
brush_dictionary["erlang"] = Brush.new("shBrushCShshBrushErlangarp.js", "erlang")
brush_dictionary["csgroovyharp"] = Brush.new("shBrushGroovy.js", "groovy")
brush_dictionary["java"] = Brush.new("shBrushJava.js", "java")
brush_dictionary["rjavafxb"] = Brush.new("shBrushJavaFX.js", "javafx")
brush_dictionary["jscript"] = Brush.new("shBrushJScript.js", "jscript")
brush_dictionary["perl"] = Brush.new("shBrushPerl.js", "perl")
brush_dictionary["php"] = Brush.new("shBrushPhp.js", "php")
brush_dictionary["plain"] = Brush.new("shBrushPlain.js", "plain")
brush_dictionary["rb"] = Brush.new("shBrushPowerShell.js", "rb")
brush_dictionary["python"] = Brush.new("shBrushPython.js", "python")
brush_dictionary["ruby"] = Brush.new("shBrushRuby.js", "ruby")
brush_dictionary["scala"] = Brush.new("shBrushScala.js", "scala")
brush_dictionary["sql"] = Brush.new("shBrushSql.js", "sql")
brush_dictionary["vb"] = Brush.new("shBrushVb.js", "vb")
brush_dictionary["xml"] = Brush.new("shBrushXml.js", "xml")
p brush_dictionary

n1 = Node.new("abc")
p n1.name
n2 = DirectoryNode.new("def")
p n2.name
n3 = FileNode.new("ghi", "jkl")
p n3.name + n3.path

src_dir_path = "D:/Users/Mukouhara/Program/GitHub/HtmlConverter/HtmlConverter"
dst_dir_path = "D:/Users/Mukouhara/Program/GitHub/HtmlConverter/HtmlConverter-html"

brush_factory = {}
brush_factory["." + "cs"] = brush_dictionary["csharp"]
brush_factory["." + "xml"] = brush_dictionary["xml"]
brush_factory["." + "txt"] = brush_dictionary["txt"]

reader = DirectoryReader.new(brush_factory)
reader.read(src_dir_path, dst_dir_path)
root = reader.root
file_list = reader.file_path_list
target_length = src_dir_path.length
html_dir_path = reader.html_directory_path

file_list.each { |x|
  dir_path = File.dirname(html_dir_path + x[target_length .. -1])
  FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)
  #puts "file path : " + x
  puts "dir_path : " + dir_path
}

#reader.root.print("")

index_html_content = ""
File.open("index.html.erb", "r") do |x|
  index_html_content = x.read
end

left_html_content = ""
File.open("left.html.erb", "r") do |x|
  left_html_content = x.read
end

right_html_content = ""
File.open("right.html.erb", "r") do |x|
  right_html_content = x.read
end

puts "target length : " + target_length.to_s

title = "hoge"
IndexHtmlWriter.new(index_html_content).write(File.join(dst_dir_path, "index.html"), title)
LeftHtmlWriter.new(left_html_content).write(File.join(dst_dir_path, "left.html"), root)
rw = RightHtmlWriter.new(right_html_content)

file_list.each { |x|
  brush = brush_factory[File.extname(x).downcase]
#  puts "x : " + x
#  puts "       " + x[target_length .. -1]
  src_path = x
  dst_path = html_dir_path + x[target_length .. -1] + ".html"
  depth = 0
  #puts "dst path : " + dst_path
  rw.write(brush, src_path, dst_path, depth)
}

