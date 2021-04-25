local S = minetest.get_translator("magic_compass")



function magic_compass.get_formspec(p_name)

  local SLOTS_PER_ROW = 5
  local y_offset = 0.3
  local rows = math.floor(table.maxn(magic_compass.items) / SLOTS_PER_ROW - 0.1) + 1
  local hidden_rows = 0
  local last_pointed_row = 0

  local formspec = {}

  -- aggiungo i vari slot (matrice i*j)
  for i = 1, rows do
    local hidden_items = 0
    local is_row_empty = true

    for j = 1, SLOTS_PER_ROW do

      local x = 0.5 + (j-1)
      local y = 0.3 + y_offset + (i - hidden_rows -1)
      local idx = SLOTS_PER_ROW * (i - hidden_rows -1) + j
      local itemID = SLOTS_PER_ROW * (i-1) + j
      local item = magic_compass.items[itemID]

      if item then
        if item.privs then
          if not item.hide or (item.hide and minetest.check_player_privs(p_name, minetest.string_to_privs(item.privs, ", "))) then
            table.insert(formspec, idx, "item_image_button[" .. x .. "," .. y .. ";1,1;magic_compass:" .. itemID .. ";" .. itemID .. ";]")
            if is_row_empty then is_row_empty = false end
          else
            table.insert(formspec, idx, "image_button[" .. x .. "," .. y .. ";1,1;blank.png;EMPTY;]")
            hidden_items = hidden_items + 1
          end
        else
          table.insert(formspec, idx, "item_image_button[" .. x .. "," .. y .. ";1,1;magic_compass:" .. itemID .. ";" .. itemID .. ";]")
          if is_row_empty then is_row_empty = false end
        end
      else
        table.insert(formspec, idx, "image_button[" .. x .. "," .. y .. ";1,1;blank.png;EMPTY;]")
      end
    end

    if not is_row_empty then
      last_pointed_row = i
    end

    -- se una riga contiene solo oggetti non visibili al giocatore, non la mostro
    if hidden_items > 0 and is_row_empty then

      hidden_rows = hidden_rows + (i - last_pointed_row)

      for k = (SLOTS_PER_ROW * (i - hidden_rows)) + 1, SLOTS_PER_ROW * i do
        formspec[k] = nil
      end

      -- fa in modo che se ci sono più aree nascoste da NON mostrare, il conteggio non svuoti linee di troppo incrementando hidden_rows più del dovuto
      last_pointed_row = i
    end



  end

  local shown_rows = rows - hidden_rows
  local bg = magic_compass["menu_gui_bg_"..shown_rows.."rows"]

  -- assegno intestazioni formspec (dimensione, sfondo ecc)
  table.insert(formspec, 1, "size[6," .. 2 + (shown_rows-1) .. "]")
  table.insert(formspec, 2, "style_type[image_button;border=false;bgimg=" .. magic_compass.menu_gui_button_bg .. "]")
  table.insert(formspec, 3, "style_type[item_image_button;border=false;bgimg=" .. magic_compass.menu_gui_button_bg .. "]")
  table.insert(formspec, 4, "hypertext[0.25,-0.2;6,1;title;<global font=mono halign=center valign=middle>" .. S(magic_compass.menu_title) .. "</style>]")

  if bg and bg ~= "" then
    table.insert(formspec, 5, "background[0,0;6," .. 1.5 + (shown_rows -1) .. ";" .. magic_compass["menu_gui_bg_"..shown_rows.."rows"] .. ";true]")
  end

  return table.concat(formspec,"")
end
