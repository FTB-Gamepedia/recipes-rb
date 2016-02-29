require 'test/unit'
require_relative '../lib/cg/crafting_table'
require_relative '../lib/recipe_parsers/shaped_ore'

class CraftingTableTest < Test::Unit::TestCase
  def test_merge
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
    cg_string = '{{Cg/Crafting Table
|A1={{O|ingotIron}}{{O|ingotIron}}
|B1={{O|nuggetGold}}{{O|nuggetGold}}
|C1={{O|ingotIron}}{{O|ingotIron}}
|A2={{O|nuggetGold}}{{O|nuggetGold}}
|B2={{O|ingotIron}}{{O|ingotIron}}
|C2={{O|nuggetGold}}{{O|nuggetGold}}
|O={{Gc|mod=V|dis=false|Bucket}}{{Gc|mod=V|dis=false|Bucket}}
}}'
    assert_equal(cg.merge(cg_test), cg_string)
    assert_equal(cg_test.merge(cg), cg_string)

    assert_equal(cg, Cg::CraftingTable.new(cg_string).remove_duplicates)
    assert_equal(cg, Cg::CraftingTable.new(cg_string).remove_duplicates!)
    assert_equal(cg_test, Cg::CraftingTable.new(cg_string).remove_duplicates)
    assert_equal(cg_test, Cg::CraftingTable.new(cg_string).remove_duplicates!)
  end
end