class Hscodes::IndexSerializer
  def initialize(@hscodes : Array(Hscode))
  end

  def render
    @hscodes.map { |hscode| ShowSerializer.new(hscode).render }
  end
end