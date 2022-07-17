# frozen_string_literal: true

class Array
  def second
    length <= 1 ? nil : self[1]
  end
end

def get_sources(path)
  YAML.load_file(path)
end
