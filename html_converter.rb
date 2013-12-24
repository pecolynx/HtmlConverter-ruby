require "./brush"
require "./node"
require "./directory_node"
require "./directory_reader"
require './index_html_writer'
require './left_html_writer'
require './right_html_writer'
require 'fileutils'

src_dir_path = ARGV[0]
dst_dir_path = ARGV[1]

if src_dir_path == nil || dst_dir_path == nil
  p 'usage : ruby html_converter.rb <src_path> <dst_path>'
  exit
end

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
#p brush_dictionary

brush_factory = {}
brush_factory["." + "cs"] = brush_dictionary["csharp"]
brush_factory["." + "xml"] = brush_dictionary["xml"]
brush_factory["." + "css"] = brush_dictionary["css"]
brush_factory["." + "js"] = brush_dictionary["js"]
brush_factory["." + "txt"] = brush_dictionary["txt"]
brush_factory["." + "html"] = brush_dictionary["xml"]

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
  #puts "dir_path : " + dir_path
}

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

#puts "target length : " + target_length.to_s

title = File.basename(src_dir_path)
p 'title : ' + title
p 'src dir path : ' + src_dir_path
p 'dst dir path : ' + dst_dir_path

# index output
IndexHtmlWriter.new(index_html_content).write(File.join(dst_dir_path, "index.html"), title)

# left output
LeftHtmlWriter.new(left_html_content).write(File.join(dst_dir_path, "left.html"), root)

# right output
rw = RightHtmlWriter.new(right_html_content)

file_list.each { |x|
  brush = brush_factory[File.extname(x).downcase]
  if brush 
    src_path = x
    dst_path = html_dir_path + x[target_length .. -1] + ".html"
    depth = x[target_length + 1 .. -1].count('/')
    #puts "dst path : " + dst_path
    rw.write(brush, src_path, dst_path, depth)
  end
}

# リソースファイルのコピー
FileUtils.copy_entry("./resources/css", File.join(dst_dir_path, 'css'));
FileUtils.copy_entry("./resources/js", File.join(dst_dir_path, 'js'));
FileUtils.copy_entry("./resources/images", File.join(dst_dir_path, 'images'));
FileUtils.cp("./right.html", File.join(dst_dir_path, 'right.html'));

p 'Done.'

