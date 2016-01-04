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

It supports ItemStacks using the following ItemStack syntax:
``` java
new ItemStack(Item.item, size, meta)
```

You should be able to copy recipe code directly from the source code of the mod and paste it into your command line.

## Main limitations
Limited to only ShapedOreRecipes. We want as many different recipe parsers as possible.