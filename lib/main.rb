require_relative 'recipe_parsers/shaped_ore'

recipe = ARGV[0]

if recipe =~ /^GameRegistry\.addRecipe\(new ShapedOreRecipe\(/
  maker = RecipeParsers::ShapedOreRecipeParser.new(recipe)
  maker.parse
else
  puts 'That recipe type is not currently supported. Please submit a PR or open an issue so we can support it.'
end