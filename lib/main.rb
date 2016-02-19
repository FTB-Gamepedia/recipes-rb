require_relative 'recipe_parsers/shaped_ore'

def go(recipe)
  if recipe =~ /^GameRegistry\.addRecipe\(new ShapedOreRecipe\(/
    puts RecipeParsers::ShapedOreRecipeParser.new(recipe).parse.to_s
    puts ''
  else
    puts 'That recipe type is not currently supported. Please submit a PR so we can support it.\n'
  end
end

if ARGV[0].nil?
  if !File.exists?('recipes.txt')
    # Kindly create it
    File.open('recipes.txt', 'w').close
  else
    file = File.open('recipes.txt', 'r')
    until file.eof?
      go(file.readline)
    end
    file.close
    puts 'Done!'
  end
else
  go(ARGV[0])
  puts 'Done!'
end
