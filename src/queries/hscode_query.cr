class HscodeQuery < Hscode::BaseQuery
  # Returns hscodes that belongs the same HS chapter
  def related
    chapter.hscodes.reject { |hs| hs.id == id }
  end
end