
class DirectoryNode < Node
  attr_reader :sub_directory_list
  attr_reader :file_list

  def initialize(name)
    super(name)
    @file_list = []
    @sub_directory_list = []
  end

  def add_directory(sub_directory)
    @sub_directory_list.push(sub_directory)
  end

  def add_file(file)
    @file_list.push(file)
  end

  def print(indent)
    #puts indent + @name

    @sub_directory_list.each { |x| 
      x.print(indent + " ")
    }

    @file_list.each { |x|
      x.print(indent + " ")
    }
  end
end
