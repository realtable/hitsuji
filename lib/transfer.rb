require_relative 'subsystem.rb'

# @private
class Transfer
  def self.export(directory, struct)
    File.open(directory, 'w') do |file|
      encoded = Marshal.dump(struct)
      file.write([encoded].pack('u'))
    end
  end

  def self.import(directory)
    File.open(directory, 'r') do |file|
      decoded = file.read.unpack('u')
      return Marshal.load(decoded.first)
    end
  end
end
