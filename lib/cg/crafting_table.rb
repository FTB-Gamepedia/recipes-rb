module Cg
  class CraftingTable
    # @return [String] The string representation of the Cg. See {#to_s}.
    attr_reader :string

    # @return [String] The A1 parameter value.
    attr_accessor :a1

    # @return [String] The B1 parameter value.
    attr_accessor :b1

    # @return [String] The C1 parameter value.
    attr_accessor :c1

    # @return [String] The A2 parameter value.
    attr_accessor :a2

    # @return [String] The B2 parameter value.
    attr_accessor :b2

    # @return [String] The C2 parameter value.
    attr_accessor :c2

    # @return [String] The A3 parameter value.
    attr_accessor :a3

    # @return [String] The B3 parameter value.
    attr_accessor :b3

    # @return [String] The C3 parameter value.
    attr_accessor :c3

    # @return [String] The O parameter value.
    attr_accessor :output

    # @return [Boolean] Whether the shapeless parameter is set.
    attr_accessor :shapeless

    # Creates a new CraftingTable object.
    # @param opts [String/Hash<Symbol, Key>] The full Cg/Crafting Table template call string, or a hash representation.
    # @option opts [String] :a1 The A1 parameter.
    # @option opts [String] :b1 The B1 parameter.
    # @option opts [String] :c1 The C1 parameter.
    # @option opts [String] :a2 The A2 parameter.
    # @option opts [String] :b2 The B2 parameter.
    # @option opts [String] :c2 The C2 parameter.
    # @option opts [String] :a3 The A3 parameter.
    # @option opts [String] :b3 The B3 parameter.
    # @option opts [String] :c3 The C3 parameter.
    # @option opts [String] :o The O parameter.
    def initialize(opts)
      if opts.is_a?(String)
        @string = opts
        @a1 = get_param('A1')
        @b1 = get_param('B1')
        @c1 = get_param('C1')
        @a2 = get_param('A2')
        @b2 = get_param('B2')
        @c2 = get_param('C2')
        @a3 = get_param('A3')
        @b3 = get_param('B3')
        @c3 = get_param('C3')
        @output = string[/\|O=(.*?)\n\}\}/m, 1]
        @shapeless = opts.include?('|shapeless=true')
      elsif opts.is_a?(Hash)
        @a1 = opts[:a1]
        @b1 = opts[:b1]
        @c1 = opts[:c1]
        @a2 = opts[:a2]
        @b2 = opts[:b2]
        @c2 = opts[:c2]
        @a3 = opts[:a3]
        @b3 = opts[:b3]
        @c3 = opts[:c3]
        @output = opts[:o]
        @shapeless = opts.key?(:shapeless)
        to_s
      end
    end

    # Converts the input data to the crafting grid template call string. This will also re-set the #string
    # attribute to the new formatted Cg.
    # @return [String] Essentially the same thing as @string.
    def to_s
      str = "{{Cg/Crafting Table\n"
      str << "|A1=#{@a1}\n" unless @a1.nil?
      str << "|B1=#{@b1}\n" unless @b1.nil?
      str << "|C1=#{@c1}\n" unless @c1.nil?
      str << "|A2=#{@a2}\n" unless @a2.nil?
      str << "|B2=#{@b2}\n" unless @b2.nil?
      str << "|C2=#{@c2}\n" unless @c2.nil?
      str << "|A3=#{@a3}\n" unless @a3.nil?
      str << "|B3=#{@b3}\n" unless @b3.nil?
      str << "|C3=#{@c3}\n" unless @c3.nil?
      str << "|O=#{@output}\n" unless @output.nil?
      str << "|shapeless=true\n" if @shapeless
      str << '}}'
      @string = str
      str
    end

    # Merges this crafting table with the other one.
    # @param other [Cg::CraftingTable] The other crafting table to merge with.
    # @return [String] The merged crafting grids. If one is shapeless and the other is not, it will not merge them.
    #   In that case, it will simply return the two Cg's sequentially: {{Cg/Crafting Table}}\n\n{{Cg/Crafting Table}}.
    #   Be careful when repeatedly merging because of this.
    def merge(other)
      if @shapeless != other.shapeless
        return "#{to_s}\n\n#{other.to_s}"
      end

      str = "{{Cg/Crafting Table\n"
      str << merge_params('A1', @a1, other.a1)
      str << merge_params('B1', @b1, other.b1)
      str << merge_params('C1', @c1, other.c1)
      str << merge_params('A2', @a2, other.a2)
      str << merge_params('B2', @b2, other.b2)
      str << merge_params('C2', @c2, other.c2)
      str << merge_params('A3', @a3, other.a3)
      str << merge_params('B3', @b3, other.b3)
      str << merge_params('C3', @c3, other.c3)
      str << merge_params('O', @output, other.output)
      str << "|shapeless=true\n" if @shapeless
      str << '}}'
      str
    end

    # Invokes the given block for each parameter, except shapeless, modifying the values in-place.
    def map!
      yield @a1 if @a1
      yield @b1 if @b1
      yield @c1 if @c1
      yield @a2 if @a2
      yield @b2 if @b2
      yield @c2 if @c2
      yield @a3 if @a3
      yield @b3 if @b3
      yield @c3 if @c3
      yield @output if @output
    end

    # Removes the duplicated (example, if it was only {{O|ingotIron}}{{O|ingotIron}} with nothing after) entries in
    # self. Modifies the Cg in place.
    # @return [Cg::CraftingTable] The modified Cg.
    def remove_duplicates!
      @a1 = remove_duplicate(@a1)
      @b1 = remove_duplicate(@b1)
      @c1 = remove_duplicate(@c1)
      @a2 = remove_duplicate(@a2)
      @b2 = remove_duplicate(@b2)
      @c2 = remove_duplicate(@c2)
      @a3 = remove_duplicate(@a3)
      @b3 = remove_duplicate(@b3)
      @c3 = remove_duplicate(@c3)
      @output = remove_duplicate(@output)
      to_s
      self
    end

    # Creates a new Cg with all duplicated entries removed.
    # @see #{remove_duplicates!} for in-place modification.
    # @return [Cg::CraftingTable] A new Cg::CraftingTable.
    def remove_duplicates
      a1 = remove_duplicate(@a1)
      b1 = remove_duplicate(@b1)
      c1 = remove_duplicate(@c1)
      a2 = remove_duplicate(@a2)
      b2 = remove_duplicate(@b2)
      c2 = remove_duplicate(@c2)
      a3 = remove_duplicate(@a3)
      b3 = remove_duplicate(@b3)
      c3 = remove_duplicate(@c3)
      output = remove_duplicate(@output)

      Cg::CraftingTable.new(a1: a1, b1: b1, c1: c1, a2: a2, b2: b2, c2: c2, a3: a3, b3: b3, c3: c3, o: output)
    end

    # Merges two crafting grids together.
    # @param one [Cg::CraftingTable] The first crafting table object.
    # @param two [Cg::CraftingTable] The second crafting table object.
    # @return See #{merge}.
    def self.merge(one, two)
      one.merge(two)
    end

    def ==(other)
      return @a1 == other.a1 && @b1 == other.b1 && @c1 == other.c1 &&
             @a2 == other.a2 && @b2 == other.b2 && @c2 == other.c2 &&
             @a3 == other.a3 && @b3 == other.b3 && @c3 == other.c3 &&
             @shapeless == other.shapeless && @output == other.output
    end

    private

    # Removes the duplicated parameters in the param string.
    # @param param [String] The Cg parameter.
    # @return [String] The new parameter.
    def remove_duplicate(param)
      return nil if param.nil?
      ary = param.split('}}').map! { |x| x << '}}' }
      if ary.uniq.length <= 1
        return ary[0]
      end
      param
    end

    # Merges two parameter calls together.
    # @param param [String] The parameter name.
    # @param one [String] The first parameter call.
    # @param two [String] The second parameter call.
    # @return [String] The merged parameter calls.
    def merge_params(param, one, two)
      if one.nil? && !two.nil?
        return "|#{param}={{Gc}}#{two}\n"
      end
      if !one.nil? && two.nil?
        return "|#{param}=#{one}{{Gc}}\n"
      end
      if one.nil? && two.nil?
        return ''
      end
      if !one.nil? && !two.nil?
        return "|#{param}=#{one}#{two}\n"
      end
    end

    # Gets the given parameter (A1, B1, etc) for the Cg/Crafting Table string.
    # This assumes that the Cg follows the proper format of having a new parameter on a newline (see #to_s).
    # @param param [String] The template parameter to obtain.
    # @return [String] Everything between param= and the newline.
    def get_param(param)
      @string[/\|#{param}=(.*?)\n/m, 1]
    end
  end
end