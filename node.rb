class Node
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class FileNode < Node
  attr_reader :path

  def initialize(name, path)
    super(name)
    @path = path
  end

  def print(indent)
    puts indent + @name
  end
end
