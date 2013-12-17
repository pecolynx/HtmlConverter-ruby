class Brush
  attr_reader :javaScript
  attr_reader :style
  
  def initialize(javaScript, style)
    @javaScript = javaScript
    @style = style
  end
end
