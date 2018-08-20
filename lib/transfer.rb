require 'subsystem'

class Transfer # :nodoc:
  def self.export(directory, struct)
    File.open(directory, 'w') { |file| file.write(Marshal.dump(struct)) }
  end

  def self.import(directory)
    File.open(directory, 'r') { |file| return Marshal.load(file.read) }
  end
end
