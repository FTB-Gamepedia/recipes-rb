require 'yaml'
require 'array_utility'
require_relative 'item_stack'

module RecipeParsers
  class ShapedOreRecipeParser
    using ArrayUtility

    # @return [String] The base recipe code snippet.
    attr_reader :recipe

    # @return [String] The output item.
    attr_reader :output

    # @return [Array<String>] The input character sequences, for example ["aaa", "aaa", "aaa"].
    attr_reader :input

    # @return [Hash<String, String>] The input character sequences and their corresponding items. These will be
    #   converted into either Gc templates or O templates accordingly.
    attr_reader :things

    PWD = Dir.pwd
    MAPPINGS = YAML.load_file("#{PWD}/mappings.yml")

    def initialize(recipe)
      @recipe = recipe
    end

    # Parses the ShapedOreRecipe into the Cg/Crafting Table recipe that can be put on the wiki. Prints it to the CL.
    # @return [String] The {{Cg/Crafting Table}} template generated.
    def parse
      actual_recipe = @recipe.split('new ShapedOreRecipe(')[1]
      # actual_recipe.gsub!(/\s/, '')
      actual_recipe.gsub!('));', '')
      actual_recipe_array = actual_recipe.scan(/(?:\(.*?\)|[^,])+/)
      @output = actual_recipe_array[0]

      @input = []
      @things = {}
      actual_recipe_array.each_with_index do |t, index|
        next if index == 0
        t[0] = '' if t[0] == ' '

        if t.size == 1
          @things[t] = actual_recipe_array.next(t)
          next
        end

        before = actual_recipe_array.before(t)
        next if before !~ /"/ && before != @output
        @input << t if t =~ /"/
      end

      @things.each do |key, ore|
        if ore !~ /"/
          if MAPPINGS.key?(ore)
            map = MAPPINGS[ore]
            @things[key] = "{{Gc|mod=#{map['mod']}|dis=false|#{map['name']}}}"
            next
          end
          if ore =~ /ItemStack/
            is = RecipeParsers::ItemStack.new(ore)
            if MAPPINGS.key?(is.item)
              @things[key] = is.gc(MAPPINGS[is.item])
            end
          end
        else
          ore.gsub!(/"/, '')
          @things[key] = "{{O|#{ore}}}"
        end
      end

      template = "{{Cg/Crafting Table\n"
      @input.each_with_index do |line, index|
        line.gsub!('"', '')
        line.each_char.with_index do |c, loc|
          next if c == ' '
          case loc
          when 0
            letter = 'A'
          when 1
            letter = 'B'
          when 2
            letter = 'C'
          else
            letter = '?'
          end

          template << "|#{letter}#{index + 1}=#{@things[c]}\n"
        end
      end

      if MAPPINGS.key?(@output)
        map = MAPPINGS[@output]
        gc = "{{Gc|mod=#{map['mod']}|dis=false|#{map['name']}}}"
        template << "|O=#{gc}\n"
      else
        if @output =~ /ItemStack/
          is = RecipeParsers::ItemStack.new(@output)
          if MAPPINGS.key?(is.item)
            template << "|O=#{is.gc(MAPPINGS[is.item])}\n"
          end
        else
          template << "|O=UNKNOWN MAPPING FOR #{@output}!\n"
        end
      end

      template << '}}'

      template
    end
  end
end
