require 'test/unit'
require_relative '../lib/recipe_parsers/shaped_ore'
require_relative '../lib/cg/crafting_table'

class ShapedOreRecipeParserTest < Test::Unit::TestCase
  def test_parse
    code = 'GameRegistry.addRecipe(new ShapedOreRecipe(Items.bucket, "oao", "aoa", o, "ingotIron", a, "nuggetGold"));'
    cg = RecipeParsers::ShapedOreRecipeParser.new(code).parse
    cg_test = Cg::CraftingTable.new({
      a1: '{{O|ingotIron}}',
      b1: '{{O|nuggetGold}}',
      c1: '{{O|ingotIron}}',
      a2: '{{O|nuggetGold}}',
      b2: '{{O|ingotIron}}',
      c2: '{{O|nuggetGold}}',
      o: '{{Gc|mod=V|dis=false|Bucket}}'})
    assert_true(cg.==(cg_test))
    assert_equal(cg.to_s, cg_test.to_s)
    cg_string = '{{Cg/Crafting Table
|A1={{O|ingotIron}}
|B1={{O|nuggetGold}}
|C1={{O|ingotIron}}
|A2={{O|nuggetGold}}
|B2={{O|ingotIron}}
|C2={{O|nuggetGold}}
|O={{Gc|mod=V|dis=false|Bucket}}
}}'
    assert_equal(cg.to_s, cg_string)
    assert_equal(cg_test.to_s, cg_string)
  end
end