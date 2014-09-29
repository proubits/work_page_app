# A work represents an image.
# A work will always have a thumbnail.
# A work normally has a camera make and model
class Work
  attr_accessor :make, :model, :thumb
  def initialize(make, model, thumb)
    @make = make
    @model = model
    @thumb = thumb
  end
end
