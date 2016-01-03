require 'yaml'
require 'array_utility'

module RecipeParsers
  class ShapedOreRecipeParser
    using ArrayUtility

    attr_reader :recipe
    attr_reader :output
    attr_reader :input

    PWD = Dir.pwd
    MAPPINGS = YAML.load_file("#{PWD}/mappings.yml")

    def initialize(recipe)
      @recipe = recipe
    end

    def parse
      actual_recipe = @recipe.split('new ShapedOreRecipe(')[1]
      # actual_recipe.gsub!(/\s/, '')
      actual_recipe.gsub!('));', '')
      actual_recipe_array = actual_recipe.split(', ')
      @output = actual_recipe_array[0]

      @input = []
      @things = {}
      actual_recipe_array.each_with_index do |t, index|
        next if index == 0
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
        template << "|O=UNKNOWN MAPPING FOR #{@output}!\n"
      end

      template << '}}'

      print "#{template}\nDone!\n"
    end
  end
end
