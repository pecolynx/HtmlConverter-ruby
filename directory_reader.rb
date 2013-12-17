require "find"
#require "file"


class DirectoryReader
  attr_reader :html_directory_path
  attr_reader :root
  attr_reader :file_path_list

  def initialize(brush_factory)
    @brush_factory = brush_factory
  end

  def read(src_directory_path, dst_directory_path)
    @html_directory_path = File.join(dst_directory_path, "html")
    title = File.basename(src_directory_path)
    directory_list = {}
    file_list = {}
    @root = DirectoryNode.new(title)
    directory_list["./html"] = @root

    # サブフォルダを含めてフォルダ内にある全てのファイルのパスを取得する
    @file_path_list = []
    Find.find(src_directory_path) { |f| 
      if File::ftype(f) != "file"
        next
      end

      ext = File.extname(f).downcase
      if ext == ""
        next
      end

      if !@brush_factory.has_key?(ext)
        next
      end



      puts "dst file path" + f
      file_path_list.push(f)
    }

    file_path_list.each { |f|

      path1 = f[src_directory_path.length .. -1]
      path2 = File.join(@html_directory_path, path1)
      path3 = path2[dst_directory_path.length .. -1]
      dst_file_path = "." + path3

      relative_dir_path = File.dirname(dst_file_path)
      while true
        if !directory_list.has_key?(relative_dir_path)
          file_name = File.basename(relative_dir_path)
          directory_list[relative_dir_path] = DirectoryNode.new(file_name)
        end

        relative_dir_path = File.dirname(relative_dir_path)
        if relative_dir_path == "."
          break
        end
      end

      relative_file_path = dst_file_path
      if !file_list.has_key?(relative_file_path)
        file_name = File.basename(relative_file_path)
        file_list[relative_file_path] = FileNode.new(file_name, relative_file_path)
      end
    }

    file_list.sort.each { |key, value|
      dir_path = File.dirname(key)
      puts "file list " + dir_path + " : " + key
      directory_list[dir_path].add_file(value)
    }

    directory_list.sort.each { |key, value|
      dir_path = File.dirname(key)
      puts "dir list " + dir_path + " : " + key
      if directory_list.has_key?(dir_path)
        directory_list[dir_path].add_directory(value)
      end
    }
  end
end
