class Hash
  def find_in_range(other)
    self[keys.find { |range| range.include? other }]
  end
end
