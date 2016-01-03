# recipes
A program to parse Minecraft Forge recipes, and turn them into FTB Wiki templates

## Using
``` shell
$ ruby lib/main.rb 'RECIPE CODE HERE'
```

For example:

``` shell
$ ruby lib/main.rb 'GameRegistry.addRecipe(new ShapedOreRecipe(Items.bucket, "oao", "aoa", 'o', "ingotIron", 'a', "nuggetGold"));'
```

## Main limitations
Limited to only Vanilla mappings, and only ShapedOreRecipes. Does not handle ItemStacks.

The former can be improved by:
1. Adding more mappings.
2. Add all mappings to an array and iterate over it.
3. Adding a parser for ItemStacks, which will require adding a metadata entry for all the mappings.

The latter can be improved by simply writing more recipe parsers for the different types of recipes added by MCF, MC, and mods.