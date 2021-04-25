# Magic Compass DOCS

### Create new locations
Every icon in the menu is a location. Locations must be declared in a .txt document inside the `locations` folder like so:
```
Red Forest                  -- the name you want to show in the menu when hovering the icon
magiccompass_redforest.png  -- the associated texture
-3.5, 5.0, -20.5            -- where the player will be teleported
5			    -- (optional) cooldown before being able to use it again. Leave empty or put -1 for none
interact, myrpg_lv10        -- (optional) privileges required in order to use it. Use ", " to separate them or it won't work
HIDE			    -- (optional) whether to hide the icon to players who don't have the required privileges
```
The file name is important too, as it must start with a number followed by an underscore like `5_whatever name.txt`.  
The number indicates the position of the associated item in the grid (which scales according to the highest number declared), and empty spaces are generated automatically if the numbers of the items don't represent a full sequence.  

### Callbacks
If you want to run additional code from an external mod of yours, there a few callbacks coming in handy:
* `magic_compass.register_on_use(function(player, ID, item_name, pos))`: use it to run more checks BEFORE being teleported. If it returns nil or false, the action is cancelled. If true, it keeps going
* `magic_compass.register_on_after_use(function(player, ID, item_name, pos))`: use it to run additional code AFTER having been teleported

### Graphic aspect
Edit `config.txt` to suit your needs!
