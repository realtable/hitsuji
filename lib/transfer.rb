require_relative 'subsystem.rb'

# The Transfer class manages the importing and exporting of Hitsuji files. This
# functionality is normally accessed through Hitsuji#import and Hitsuji#export.
# Transfer.export also does not work independently, and must be used through the
# Hitsuji#export function.
class Transfer
  def self.export(directory, struct, metadata)
    throw 'err' unless directory.end_with?('.hitsuji')
    File.open(directory, 'w') do |file|
      raw_data = { struct: struct, metadata: metadata }
      serialized_data = [Marshal.dump(raw_data)].pack('u')
      file.write serialized_data
    end
  end

  def self.import(directory)
    throw 'err' unless directory.end_with?('.hitsuji')
    File.open(directory, 'r') do |file|
      serialized_data = file.read.unpack('u')
      raw_data = Marshal.load(serialized_data.first)
      return raw_data[:struct], raw_data[:metadata]
    end
  end
end
