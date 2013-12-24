class Brush
  attr_reader :javascript
  attr_reader :style
  
  def initialize(javascript, style)
    @javascript = javascript
    @style = style
  end
end
