# control class
class Control
  # Updates state of system to monitor name usage and dependencies on
  # operations. This is run every time Hitsuji.bind is run.
  #
  # ==== Attributes
  #
  # * +obj+ - the object to update (usually @struct)
  #
  # ==== Example
  #
  #    class MyHitsuji < Hitsuji                      # creates dependent class
  #      def linker_update                            # my new special function!
  #        @struct.each do |i|
  #          update(@struct) if i.class == Linker     # uses update function
  #        end
  #      end
  #    end
  def self.update(obj)
    names = []

    obj.each do |i|
      throw 'err' unless i.name.nil? || !names.include?(i.name)
      names << update(i.value) if i.class == Linker
    end

    names
  end

  # Gets value of item from @struct and returns it. It can perform additional
  # operations such as editing and removal.
  #
  # ==== Attributes
  #
  # * +query+ - the name of the object to perform the actions on
  # * +obj+ - the object to search in (usually @struct)
  # * +edit+ - the edit to make to the object (nil if not)
  # * +remove+ - whether to remove the object (false if not)
  #
  # ==== Example
  #
  #    class MyHitsuji < Hitsuji                      # creates dependent class
  #      def remove_from_linkers(query)               # my new special function!
  #        @struct.each do |i|
  #          if i.class == Linker
  #            get(query, @struct, nil, true)         # uses get function
  #          end
  #        end
  #      end
  #    end
  def self.get(query, obj, edit, remove)
    answer = nil

    obj.each do |i|
      if i.name == query
        answer = i
        if edit
          i.value = edit
        elsif remove
          i.name = nil
        end
      elsif i.class == Linker
        answer = view(query, i.value, edit, remove)
      end
    end

    answer
  end
end
