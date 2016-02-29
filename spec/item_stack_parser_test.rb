require 'test/unit'
require_relative '../lib/recipe_parsers/item_stack'
require_relative '../lib/recipe_parsers/shaped_ore'

class ItemStackParserTest < Test::Unit::TestCase
  def test_gc
    # TODO Make MAPPINGS more public or something.
    itemstack = RecipeParsers::ItemStack.new('new ItemStack(Items.apple);')
    assert_equal('{{Gc|mod=V|dis=false|Apple}}', itemstack.gc(RecipeParsers::ShapedOreRecipeParser::MAPPINGS['Items.apple']))

    itemstack = RecipeParsers::ItemStack.new('new ItemStack(Items.fish, 1, 1);')
    assert_equal('{{Gc|mod=V|dis=false|Raw Salmon}}', itemstack.gc(RecipeParsers::ShapedOreRecipeParser::MAPPINGS['Items.fish']))

    itemstack = RecipeParsers::ItemStack.new('new ItemStack(Items.fish, 5, 1);')
    assert_equal('{{Gc|mod=V|dis=false|Raw Salmon|5}}', itemstack.gc(RecipeParsers::ShapedOreRecipeParser::MAPPINGS['Items.fish']))
  end
end