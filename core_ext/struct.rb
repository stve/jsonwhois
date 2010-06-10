class Struct  
  def to_json(*args)
    hash.to_json(*args)
  end
end