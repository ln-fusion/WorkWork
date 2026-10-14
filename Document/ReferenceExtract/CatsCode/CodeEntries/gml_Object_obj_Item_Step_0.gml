if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (Selected == 0)
    {
        if (Master != -4 && instance_exists(Master))
        {
            x = Master.x + relative_x;
            y = Master.y + relative_y;
            if (Master.Selected == 1)
            {
                depth = layer_get_depth("Dice") - 3;
            }
            else
            {
                depth = layer_get_depth("Item");
            }
        }
    }
    else if (Selected == 1)
    {
        x = obj_Cursor.x;
        y = obj_Cursor.y;
    }
    switch (global.Phase)
    {
        case "Play":
            if (Selected == 0)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (Moused_over == 0)
                    {
                        audio_play_sound(sfx_Item_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                        if (instance_exists(obj_UI_Cat_body))
                        {
                            with (obj_UI_Cat_body)
                            {
                                if (Master != other.id)
                                {
                                    instance_destroy();
                                    with (obj_UI_Cat_head)
                                    {
                                        instance_destroy();
                                    }
                                }
                            }
                        }
                        Anim_state = 1;
                    }
                    Moused_over = 1;
                    if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                    {
                        with (instance_create_layer(x, y - 24, "UI", obj_UI_Cat_head))
                        {
                            Master = other.id;
                            Text_head = other.Text_Item;
                        }
                        var var_y = 0;
                        draw_set_font(global.font_norm1);
                        with (instance_create_layer(x - 86, y + 14, "UI", obj_UI_Cat_body))
                        {
                            Master = other.id;
                            Text_body = other.Text_Passive;
                            Cat_num = other.Item_num;
                            Cat_chips = other.Item_chips;
                            Cat_mult = other.Item_mult;
                            Round_chips = other.Round_chips;
                            Round_mult = other.Round_mult;
                            var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                            switch (var_lines)
                            {
                                case 0:
                                    var_y += 17;
                                    break;
                                case 1:
                                    currentspr = spr_UI_Cat_body2;
                                    var_y += 30;
                                    break;
                                case 2:
                                    currentspr = spr_UI_Cat_body3;
                                    var_y += 42;
                                    break;
                            }
                        }
                        if (array_length(Dice_effect) > 0)
                        {
                            var var_num = 0;
                            for (var var_i = 0; var_i < array_length(Dice_effect); var_i += 1)
                            {
                                var var_text = "";
                                ini_open(global.lang_file);
                                switch (Dice_effect[var_i][0])
                                {
                                    case "<>":
                                        var_text = ini_read_string("Mechanics_text", "Bling_effect", "");
                                        break;
                                    case "M":
                                        var_text = ini_read_string("Mechanics_text", "Mark_effect", "");
                                        break;
                                    case "$":
                                        var_text = ini_read_string("Mechanics_text", "Dollar_effect", "");
                                        break;
                                    case "R":
                                        var_text = ini_read_string("Mechanics_text", "Reroll_effect", "");
                                        break;
                                    case "^R":
                                        var var_cantrip = ini_read_string("Mechanics_text", "Cantrip_effect", "");
                                        var_text = ini_read_string("Mechanics_text", "Reroll_effect", "");
                                        ini_close();
                                        var var_exist = 0;
                                        with (obj_UI_Dice_body)
                                        {
                                            if (Text_body == var_cantrip)
                                            {
                                                var_exist = 1;
                                            }
                                        }
                                        if (var_exist == 0)
                                        {
                                            with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                            {
                                                Master = other.id;
                                                Creation_num = var_num;
                                                Text_body = var_cantrip;
                                                var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                                switch (var_lines)
                                                {
                                                    case 0:
                                                        currentspr = spr_UI_Dice_body;
                                                        var_y += 16;
                                                        break;
                                                    case 1:
                                                        currentspr = spr_UI_Dice_body2;
                                                        var_y += 28;
                                                        break;
                                                    case 2:
                                                        currentspr = spr_UI_Dice_body3;
                                                        var_y += 40;
                                                        break;
                                                }
                                            }
                                            var_num += 1;
                                        }
                                        break;
                                    case "^Add":
                                        var var_cantrip = ini_read_string("Mechanics_text", "Cantrip_effect", "");
                                        var_text = ini_read_string("Mechanics_text", "Add_effect", "");
                                        ini_close();
                                        var var_exist = 0;
                                        with (obj_UI_Dice_body)
                                        {
                                            if (Text_body == var_cantrip)
                                            {
                                                var_exist = 1;
                                            }
                                        }
                                        if (var_exist == 0)
                                        {
                                            with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                            {
                                                Master = other.id;
                                                Creation_num = var_num;
                                                Text_body = var_cantrip;
                                                var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                                switch (var_lines)
                                                {
                                                    case 0:
                                                        currentspr = spr_UI_Dice_body;
                                                        var_y += 16;
                                                        break;
                                                    case 1:
                                                        currentspr = spr_UI_Dice_body2;
                                                        var_y += 28;
                                                        break;
                                                    case 2:
                                                        currentspr = spr_UI_Dice_body3;
                                                        var_y += 40;
                                                        break;
                                                }
                                            }
                                            var_num += 1;
                                        }
                                        break;
                                    case "Spade":
                                        var_text = ini_read_string("Mechanics_text", "Spade_effect", "");
                                        break;
                                    case "Heart":
                                        var_text = ini_read_string("Mechanics_text", "Heart_effect", "");
                                        break;
                                    case "Boost":
                                        var_text = ini_read_string("Mechanics_text", "Boost_effect", "");
                                        break;
                                    case "D":
                                        var_text = ini_read_string("Mechanics_text", "Duplicate_effect", "");
                                        break;
                                    case "P+":
                                        var_text = ini_read_string("Mechanics_text", "Support_effect", "");
                                        break;
                                    case "SS":
                                        var_text = ini_read_string("Mechanics_text", "SS_effect", "");
                                        break;
                                    case "X2":
                                        var_text = ini_read_string("Mechanics_text", "Double_effect", "");
                                        break;
                                }
                                ini_close();
                                with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                {
                                    Master = other.id;
                                    Creation_num = var_num;
                                    Text_body = var_text;
                                    var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                    switch (var_lines)
                                    {
                                        case 0:
                                            currentspr = spr_UI_Dice_body;
                                            var_y += 16;
                                            break;
                                        case 1:
                                            currentspr = spr_UI_Dice_body2;
                                            var_y += 28;
                                            break;
                                        case 2:
                                            currentspr = spr_UI_Dice_body3;
                                            var_y += 40;
                                            break;
                                        case 3:
                                            currentspr = spr_UI_Dice_body3;
                                            var_y += 40;
                                            break;
                                    }
                                }
                                var_num += 1;
                            }
                        }
                        draw_set_font(global.font_big1);
                    }
                }
                else
                {
                    Moused_over = 0;
                }
            }
            break;
        case "Shop":
            if (Hold_check == 11)
            {
                Hold_check = 0;
            }
            else if (Hold_check >= 1)
            {
                if (global.Lmouse_click)
                {
                    Hold_check += 1;
                    if (Hold_check >= 10)
                    {
                        Hold_check = 10;
                    }
                }
                else if (!global.Lmouse_click)
                {
                    if (Hold_check == 10)
                    {
                        Hold_check = 11;
                    }
                    else
                    {
                        Hold_check = 0;
                    }
                }
            }
            if (Shop_created == 0)
            {
                if (Selected == 0)
                {
                    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                    {
                        if (Moused_over == 0)
                        {
                            audio_play_sound(sfx_Item_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                            if (instance_exists(obj_UI_Cat_body))
                            {
                                with (obj_UI_Cat_body)
                                {
                                    if (Master != other.id)
                                    {
                                        instance_destroy();
                                        with (obj_UI_Cat_head)
                                        {
                                            instance_destroy();
                                        }
                                    }
                                }
                            }
                            Anim_state = 1;
                        }
                        Moused_over = 1;
                        if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                        {
                            with (instance_create_layer(x, y - 24, "UI", obj_UI_Cat_head))
                            {
                                Master = other.id;
                                Text_head = other.Text_Item;
                            }
                            var var_y = 0;
                            draw_set_font(global.font_norm1);
                            with (instance_create_layer(x - 86, y + 14, "UI", obj_UI_Cat_body))
                            {
                                Master = other.id;
                                Text_body = other.Text_Passive;
                                Cat_num = other.Item_num;
                                Cat_chips = other.Item_chips;
                                Cat_mult = other.Item_mult;
                                Round_chips = other.Round_chips;
                                Round_mult = other.Round_mult;
                                var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                                switch (var_lines)
                                {
                                    case 0:
                                        var_y += 17;
                                        break;
                                    case 1:
                                        currentspr = spr_UI_Cat_body2;
                                        var_y += 30;
                                        break;
                                    case 2:
                                        currentspr = spr_UI_Cat_body3;
                                        var_y += 42;
                                        break;
                                }
                            }
                            if (array_length(Dice_effect) > 0)
                            {
                                var var_num = 0;
                                for (var var_i = 0; var_i < array_length(Dice_effect); var_i += 1)
                                {
                                    var var_text = "";
                                    ini_open(global.lang_file);
                                    switch (Dice_effect[var_i][0])
                                    {
                                        case "<>":
                                            var_text = ini_read_string("Mechanics_text", "Bling_effect", "");
                                            break;
                                        case "M":
                                            var_text = ini_read_string("Mechanics_text", "Mark_effect", "");
                                            break;
                                        case "$":
                                            var_text = ini_read_string("Mechanics_text", "Dollar_effect", "");
                                            break;
                                        case "R":
                                            var_text = ini_read_string("Mechanics_text", "Reroll_effect", "");
                                            break;
                                        case "^R":
                                            var var_cantrip = ini_read_string("Mechanics_text", "Cantrip_effect", "");
                                            var_text = ini_read_string("Mechanics_text", "Reroll_effect", "");
                                            ini_close();
                                            var var_exist = 0;
                                            with (obj_UI_Dice_body)
                                            {
                                                if (Text_body == var_cantrip)
                                                {
                                                    var_exist = 1;
                                                }
                                            }
                                            if (var_exist == 0)
                                            {
                                                with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                                {
                                                    Master = other.id;
                                                    Creation_num = var_num;
                                                    Text_body = var_cantrip;
                                                    var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                                    switch (var_lines)
                                                    {
                                                        case 0:
                                                            currentspr = spr_UI_Dice_body;
                                                            var_y += 16;
                                                            break;
                                                        case 1:
                                                            currentspr = spr_UI_Dice_body2;
                                                            var_y += 28;
                                                            break;
                                                        case 2:
                                                            currentspr = spr_UI_Dice_body3;
                                                            var_y += 40;
                                                            break;
                                                    }
                                                }
                                                var_num += 1;
                                            }
                                            break;
                                        case "^Add":
                                            var var_cantrip = ini_read_string("Mechanics_text", "Cantrip_effect", "");
                                            var_text = ini_read_string("Mechanics_text", "Add_effect", "");
                                            ini_close();
                                            var var_exist = 0;
                                            with (obj_UI_Dice_body)
                                            {
                                                if (Text_body == var_cantrip)
                                                {
                                                    var_exist = 1;
                                                }
                                            }
                                            if (var_exist == 0)
                                            {
                                                with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                                {
                                                    Master = other.id;
                                                    Creation_num = var_num;
                                                    Text_body = var_cantrip;
                                                    var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                                    switch (var_lines)
                                                    {
                                                        case 0:
                                                            currentspr = spr_UI_Dice_body;
                                                            var_y += 16;
                                                            break;
                                                        case 1:
                                                            currentspr = spr_UI_Dice_body2;
                                                            var_y += 28;
                                                            break;
                                                        case 2:
                                                            currentspr = spr_UI_Dice_body3;
                                                            var_y += 40;
                                                            break;
                                                    }
                                                }
                                                var_num += 1;
                                            }
                                            break;
                                        case "Spade":
                                            var_text = ini_read_string("Mechanics_text", "Spade_effect", "");
                                            break;
                                        case "Heart":
                                            var_text = ini_read_string("Mechanics_text", "Heart_effect", "");
                                            break;
                                        case "Boost":
                                            var_text = ini_read_string("Mechanics_text", "Boost_effect", "");
                                            break;
                                        case "D":
                                            var_text = ini_read_string("Mechanics_text", "Duplicate_effect", "");
                                            break;
                                        case "P+":
                                            var_text = ini_read_string("Mechanics_text", "Support_effect", "");
                                            break;
                                        case "SS":
                                            var_text = ini_read_string("Mechanics_text", "SS_effect", "");
                                            break;
                                        case "X2":
                                            var_text = ini_read_string("Mechanics_text", "Double_effect", "");
                                            break;
                                    }
                                    ini_close();
                                    with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                    {
                                        Master = other.id;
                                        Creation_num = var_num;
                                        Text_body = var_text;
                                        var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                        switch (var_lines)
                                        {
                                            case 0:
                                                currentspr = spr_UI_Dice_body;
                                                var_y += 16;
                                                break;
                                            case 1:
                                                currentspr = spr_UI_Dice_body2;
                                                var_y += 28;
                                                break;
                                            case 2:
                                                currentspr = spr_UI_Dice_body3;
                                                var_y += 40;
                                                break;
                                            case 3:
                                                currentspr = spr_UI_Dice_body3;
                                                var_y += 40;
                                                break;
                                        }
                                    }
                                    var_num += 1;
                                }
                            }
                            draw_set_font(global.font_big1);
                        }
                        if (global.Lmouse_pressed)
                        {
                            if (!place_meeting(x, y, obj_Item))
                            {
                                audio_play_sound(sfx_Item_select, 90, false, global.Ctrl_SFX, 0, 1);
                                Hold_check = 1;
                                Selected = 1;
                                depth = layer_get_depth("Dice") - 2;
                                with (obj_Cursor)
                                {
                                    Holding = "Item";
                                }
                                if (Master != -4)
                                {
                                    var var_num = Item_passivenum;
                                    with (Master)
                                    {
                                        Item_slot[other.Item_pos] = -1;
                                        Passive[var_num] = -4;
                                        Passive_skip[var_num] = 0;
                                        Cat_num[var_num] = -1;
                                        Cat_chips[var_num] = -1;
                                        Cat_mult[var_num] = -1;
                                        Round_chips[var_num] = 0;
                                        Round_mult[var_num] = 0;
                                        Round_perm[var_num] = 0;
                                        Cat_track[var_num] = 0;
                                        scr_Item_unequip();
                                    }
                                    scr_Cat_positionplace_check(-4, -4);
                                    Master = -4;
                                    relative_x = 0;
                                    relative_y = 0;
                                    Item_passivenum = 0;
                                    Item_pos = 0;
                                }
                            }
                        }
                    }
                    else
                    {
                        Moused_over = 0;
                    }
                }
                else if (Selected == 0.9)
                {
                    Selected = 1;
                    depth = layer_get_depth("Dice") - 2;
                }
                else if (Selected == 1)
                {
                    if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Dice_tray))
                    {
                        if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            audio_play_sound(sfx_Item_place, 90, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                            audio_play_sound(sfx_UI_money_gain, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            global.Player_gold += ceil(0.5 * Item_cost);
                            instance_destroy();
                            with (obj_Cursor)
                            {
                                wait_counter = 1;
                            }
                        }
                    }
                    else if (place_meeting(x, y, obj_Cat))
                    {
                        if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            var var_cat = instance_place(x, y, obj_Cat);
                            var var_placement = -1;
                            if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x - 37, var_cat.y - 84, var_cat.x - 17, var_cat.y - 64))
                            {
                                var_placement = 0;
                            }
                            else if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x + 37, var_cat.y - 84, var_cat.x + 17, var_cat.y - 64))
                            {
                                var_placement = 1;
                            }
                            else if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x - 37, var_cat.y - 20, var_cat.x - 17, var_cat.y))
                            {
                                var_placement = 2;
                            }
                            else if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x + 37, var_cat.y - 20, var_cat.x + 17, var_cat.y))
                            {
                                var_placement = 3;
                            }
                            if (var_placement == -1)
                            {
                                audio_play_sound(sfx_UI_invalid, 80, false, global.Ctrl_SFX, 0, 1);
                            }
                            else
                            {
                                audio_play_sound(sfx_Item_place, 90, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                                Anim_state = 1;
                                if (var_cat.Item_slot[var_placement] != -4)
                                {
                                    if (var_cat.Item_slot[var_placement] == -1)
                                    {
                                        with (var_cat)
                                        {
                                            Item_slot[var_placement] = other.Item_type;
                                            Passive[var_placement + 1] = Item_slot[var_placement];
                                            scr_Item_unequip();
                                        }
                                        switch (var_placement)
                                        {
                                            case 0:
                                                x = var_cat.x - 27;
                                                y = var_cat.y - 74;
                                                break;
                                            case 1:
                                                x = var_cat.x + 27;
                                                y = var_cat.y - 74;
                                                break;
                                            case 2:
                                                x = var_cat.x - 27;
                                                y = var_cat.y - 10;
                                                break;
                                            case 3:
                                                x = var_cat.x + 27;
                                                y = var_cat.y - 10;
                                                break;
                                        }
                                        Selected = 0;
                                        depth = layer_get_depth("Item");
                                        Master = var_cat;
                                        relative_x = x - var_cat.x;
                                        relative_y = y - var_cat.y;
                                        Item_passivenum = var_placement + 1;
                                        Item_pos = var_placement;
                                        scr_Cat_positionplace_check(-4, -4);
                                        with (obj_Cursor)
                                        {
                                            wait_counter = 1;
                                        }
                                    }
                                    else
                                    {
                                        var var_item = instance_place(x, y, obj_Item);
                                        x = var_item.x;
                                        y = var_item.y;
                                        with (var_cat)
                                        {
                                            Cat_num[var_placement + 1] = -1;
                                            Cat_chips[var_placement + 1] = -1;
                                            Cat_mult[var_placement + 1] = -1;
                                            Round_chips[var_placement + 1] = 0;
                                            Round_mult[var_placement + 1] = 0;
                                            Round_perm[var_placement + 1] = 0;
                                            Cat_track[var_placement + 1] = 0;
                                            Item_slot[var_placement] = other.Item_type;
                                            Passive[var_placement + 1] = Item_slot[var_placement];
                                            scr_Item_unequip();
                                        }
                                        Selected = 0;
                                        depth = layer_get_depth("Item");
                                        Master = var_cat;
                                        relative_x = x - var_cat.x;
                                        relative_y = y - var_cat.y;
                                        Item_passivenum = var_placement + 1;
                                        Item_pos = var_placement;
                                        scr_Cat_positionplace_check(-4, -4);
                                        with (var_item)
                                        {
                                            Selected = 0.9;
                                            Master = -4;
                                            relative_x = 0;
                                            relative_y = 0;
                                            Item_passivenum = 0;
                                            Item_pos = 0;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (global.Lmouse_pressed || Hold_check == 11)
                    {
                        audio_play_sound(sfx_UI_invalid, 80, false, global.Ctrl_SFX, 0, 1);
                    }
                }
            }
            else if (Shop_created == 1)
            {
                if (Anim_state == 0 || Anim_state >= 1)
                {
                    if (Selected == 0)
                    {
                        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && obj_Cursor.Holding == 0)
                        {
                            if (Moused_over == 0)
                            {
                                audio_play_sound(sfx_Item_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                                if (instance_exists(obj_UI_Cat_body))
                                {
                                    with (obj_UI_Cat_body)
                                    {
                                        if (Master != other.id)
                                        {
                                            instance_destroy();
                                            with (obj_UI_Cat_head)
                                            {
                                                instance_destroy();
                                            }
                                        }
                                    }
                                }
                                Anim_state = 1;
                            }
                            Moused_over = 1;
                            if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                            {
                                with (instance_create_layer(x, y - 24, "UI", obj_UI_Cat_head))
                                {
                                    Master = other.id;
                                    Text_head = other.Text_Item;
                                }
                                var var_y = 0;
                                draw_set_font(global.font_norm1);
                                with (instance_create_layer(x - 86, y + 14, "UI", obj_UI_Cat_body))
                                {
                                    Master = other.id;
                                    Text_body = other.Text_Passive;
                                    Cat_num = other.Item_num;
                                    Cat_chips = other.Item_chips;
                                    Cat_mult = other.Item_mult;
                                    Round_chips = other.Round_chips;
                                    Round_mult = other.Round_mult;
                                    var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                                    switch (var_lines)
                                    {
                                        case 0:
                                            var_y += 17;
                                            break;
                                        case 1:
                                            currentspr = spr_UI_Cat_body2;
                                            var_y += 30;
                                            break;
                                        case 2:
                                            currentspr = spr_UI_Cat_body3;
                                            var_y += 42;
                                            break;
                                    }
                                }
                                if (array_length(Dice_effect) > 0)
                                {
                                    var var_num = 0;
                                    for (var var_i = 0; var_i < array_length(Dice_effect); var_i += 1)
                                    {
                                        var var_text = "";
                                        ini_open(global.lang_file);
                                        switch (Dice_effect[var_i][0])
                                        {
                                            case "<>":
                                                var_text = ini_read_string("Mechanics_text", "Bling_effect", "");
                                                break;
                                            case "M":
                                                var_text = ini_read_string("Mechanics_text", "Mark_effect", "");
                                                break;
                                            case "$":
                                                var_text = ini_read_string("Mechanics_text", "Dollar_effect", "");
                                                break;
                                            case "R":
                                                var_text = ini_read_string("Mechanics_text", "Reroll_effect", "");
                                                break;
                                            case "^R":
                                                var var_cantrip = ini_read_string("Mechanics_text", "Cantrip_effect", "");
                                                var_text = ini_read_string("Mechanics_text", "Reroll_effect", "");
                                                ini_close();
                                                var var_exist = 0;
                                                with (obj_UI_Dice_body)
                                                {
                                                    if (Text_body == var_cantrip)
                                                    {
                                                        var_exist = 1;
                                                    }
                                                }
                                                if (var_exist == 0)
                                                {
                                                    with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                                    {
                                                        Master = other.id;
                                                        Creation_num = var_num;
                                                        Text_body = var_cantrip;
                                                        var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                                        switch (var_lines)
                                                        {
                                                            case 0:
                                                                currentspr = spr_UI_Dice_body;
                                                                var_y += 16;
                                                                break;
                                                            case 1:
                                                                currentspr = spr_UI_Dice_body2;
                                                                var_y += 28;
                                                                break;
                                                            case 2:
                                                                currentspr = spr_UI_Dice_body3;
                                                                var_y += 40;
                                                                break;
                                                        }
                                                    }
                                                    var_num += 1;
                                                }
                                                break;
                                            case "^Add":
                                                var var_cantrip = ini_read_string("Mechanics_text", "Cantrip_effect", "");
                                                var_text = ini_read_string("Mechanics_text", "Add_effect", "");
                                                ini_close();
                                                var var_exist = 0;
                                                with (obj_UI_Dice_body)
                                                {
                                                    if (Text_body == var_cantrip)
                                                    {
                                                        var_exist = 1;
                                                    }
                                                }
                                                if (var_exist == 0)
                                                {
                                                    with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                                    {
                                                        Master = other.id;
                                                        Creation_num = var_num;
                                                        Text_body = var_cantrip;
                                                        var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                                        switch (var_lines)
                                                        {
                                                            case 0:
                                                                currentspr = spr_UI_Dice_body;
                                                                var_y += 16;
                                                                break;
                                                            case 1:
                                                                currentspr = spr_UI_Dice_body2;
                                                                var_y += 28;
                                                                break;
                                                            case 2:
                                                                currentspr = spr_UI_Dice_body3;
                                                                var_y += 40;
                                                                break;
                                                        }
                                                    }
                                                    var_num += 1;
                                                }
                                                break;
                                            case "Spade":
                                                var_text = ini_read_string("Mechanics_text", "Spade_effect", "");
                                                break;
                                            case "Heart":
                                                var_text = ini_read_string("Mechanics_text", "Heart_effect", "");
                                                break;
                                            case "Boost":
                                                var_text = ini_read_string("Mechanics_text", "Boost_effect", "");
                                                break;
                                            case "D":
                                                var_text = ini_read_string("Mechanics_text", "Duplicate_effect", "");
                                                break;
                                            case "P+":
                                                var_text = ini_read_string("Mechanics_text", "Support_effect", "");
                                                break;
                                            case "SS":
                                                var_text = ini_read_string("Mechanics_text", "SS_effect", "");
                                                break;
                                            case "X2":
                                                var_text = ini_read_string("Mechanics_text", "Double_effect", "");
                                                break;
                                        }
                                        ini_close();
                                        with (instance_create_layer(x - 86, y + 14 + var_y, "UI", obj_UI_Dice_body))
                                        {
                                            Master = other.id;
                                            Creation_num = var_num;
                                            Text_body = var_text;
                                            var var_lines = scr_Text_draw(x, y, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
                                            switch (var_lines)
                                            {
                                                case 0:
                                                    currentspr = spr_UI_Dice_body;
                                                    var_y += 16;
                                                    break;
                                                case 1:
                                                    currentspr = spr_UI_Dice_body2;
                                                    var_y += 28;
                                                    break;
                                                case 2:
                                                    currentspr = spr_UI_Dice_body3;
                                                    var_y += 40;
                                                    break;
                                                case 3:
                                                    currentspr = spr_UI_Dice_body3;
                                                    var_y += 40;
                                                    break;
                                            }
                                        }
                                        var_num += 1;
                                    }
                                }
                                draw_set_font(global.font_big1);
                            }
                            if (global.Lmouse_pressed)
                            {
                                if (global.Player_gold >= Item_cost)
                                {
                                    audio_play_sound(sfx_Item_select, 90, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                                    Anim_state = 1;
                                    Hold_check = 1;
                                    Selected = 1;
                                    depth = layer_get_depth("Dice") - 2;
                                    with (obj_Cursor)
                                    {
                                        Holding = "Item_buy";
                                    }
                                }
                                else
                                {
                                    audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                                }
                            }
                        }
                        else
                        {
                            Moused_over = 0;
                        }
                    }
                    else if (Selected == 1)
                    {
                        if (place_meeting(x, y, obj_Cat))
                        {
                            var var_cat = instance_place(x, y, obj_Cat);
                            if (global.Lmouse_pressed || Hold_check == 11)
                            {
                                if (var_cat.Shop_created == 0)
                                {
                                    var var_placement = -1;
                                    if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x - 37, var_cat.y - 84, var_cat.x - 17, var_cat.y - 64))
                                    {
                                        var_placement = 0;
                                    }
                                    else if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x + 37, var_cat.y - 84, var_cat.x + 17, var_cat.y - 64))
                                    {
                                        var_placement = 1;
                                    }
                                    else if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x - 37, var_cat.y - 20, var_cat.x - 17, var_cat.y))
                                    {
                                        var_placement = 2;
                                    }
                                    else if (rectangle_in_rectangle(x - 9, y - 9, x + 9, y + 9, var_cat.x + 37, var_cat.y - 20, var_cat.x + 17, var_cat.y))
                                    {
                                        var_placement = 3;
                                    }
                                    if (var_placement == -1)
                                    {
                                        audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                                    }
                                    else if (var_cat.Item_slot[var_placement] != -4)
                                    {
                                        audio_play_sound(sfx_Item_place, 90, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                                        audio_play_sound(sfx_UI_money_spent, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                        Anim_state = 1;
                                        Selected = 0;
                                        Shop_created = 0;
                                        depth = layer_get_depth("Item");
                                        global.Player_gold -= Item_cost;
                                        with (global_Level)
                                        {
                                            if (Shop_item[0] == other.Item_type)
                                            {
                                                Shop_item[0] = -4;
                                            }
                                            else if (Shop_item[1] == other.Item_type)
                                            {
                                                Shop_item[1] = -4;
                                            }
                                            else if (Shop_item[2] == other.Item_type)
                                            {
                                                Shop_item[2] = -4;
                                            }
                                        }
                                        if (var_cat.Item_slot[var_placement] == -1)
                                        {
                                            with (var_cat)
                                            {
                                                Item_slot[var_placement] = other.Item_type;
                                                Passive[var_placement + 1] = Item_slot[var_placement];
                                                scr_Item_unequip();
                                            }
                                            switch (var_placement)
                                            {
                                                case 0:
                                                    x = var_cat.x - 27;
                                                    y = var_cat.y - 74;
                                                    break;
                                                case 1:
                                                    x = var_cat.x + 27;
                                                    y = var_cat.y - 74;
                                                    break;
                                                case 2:
                                                    x = var_cat.x - 27;
                                                    y = var_cat.y - 10;
                                                    break;
                                                case 3:
                                                    x = var_cat.x + 27;
                                                    y = var_cat.y - 10;
                                                    break;
                                            }
                                            Master = var_cat;
                                            relative_x = x - var_cat.x;
                                            relative_y = y - var_cat.y;
                                            Item_passivenum = var_placement + 1;
                                            Item_pos = var_placement;
                                            scr_Cat_positionplace_check(-4, -4);
                                            with (obj_Cursor)
                                            {
                                                wait_counter = 1;
                                            }
                                        }
                                        else
                                        {
                                            var var_item = instance_place(x, y, obj_Item);
                                            x = var_item.x;
                                            y = var_item.y;
                                            with (var_cat)
                                            {
                                                Cat_num[var_placement + 1] = -1;
                                                Cat_chips[var_placement + 1] = -1;
                                                Cat_mult[var_placement + 1] = -1;
                                                Round_chips[var_placement + 1] = 0;
                                                Round_mult[var_placement + 1] = 0;
                                                Round_perm[var_placement + 1] = 0;
                                                Cat_track[var_placement + 1] = 0;
                                                Item_slot[var_placement] = other.Item_type;
                                                Passive[var_placement + 1] = Item_slot[var_placement];
                                                scr_Item_unequip();
                                            }
                                            Master = var_cat;
                                            relative_x = x - var_cat.x;
                                            relative_y = y - var_cat.y;
                                            Item_passivenum = var_placement + 1;
                                            Item_pos = var_placement;
                                            scr_Cat_positionplace_check(-4, -4);
                                            with (var_item)
                                            {
                                                Selected = 0.9;
                                                Master = -4;
                                                relative_x = 0;
                                                relative_y = 0;
                                                Item_passivenum = 0;
                                                Item_pos = 0;
                                            }
                                            with (obj_Cursor)
                                            {
                                                Holding = "Item";
                                            }
                                        }
                                    }
                                }
                                else if (var_cat.Shop_created == 1)
                                {
                                    audio_play_sound(sfx_Cat_move, 70, false, global.Ctrl_SFX, 0, random_range(1.12, 1.2));
                                    Selected = 0;
                                    depth = layer_get_depth("Item");
                                    x = obj_Dice_tray.x + obj_Dice_tray.Set_item_x + (Item_pos * obj_Dice_tray.Set_item_gap);
                                    y = obj_Dice_tray.y + obj_Dice_tray.Set_item_y;
                                    with (obj_Cursor)
                                    {
                                        wait_counter = 1;
                                    }
                                }
                            }
                        }
                        else if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            audio_play_sound(sfx_Cat_move, 70, false, global.Ctrl_SFX, 0, random_range(1.12, 1.2));
                            Selected = 0;
                            depth = layer_get_depth("Item");
                            x = obj_Dice_tray.x + obj_Dice_tray.Set_item_x + (Item_pos * obj_Dice_tray.Set_item_gap);
                            y = obj_Dice_tray.y + obj_Dice_tray.Set_item_y;
                            with (obj_Cursor)
                            {
                                wait_counter = 1;
                            }
                        }
                    }
                }
            }
            break;
    }
    switch (Anim_state)
    {
        case -1:
            scale_spd = scr_Approach(scale_spd, 0.12, 0.004 * global.deltaTime);
            xscale = scr_Approach(xscale, 1.6, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 1.6, scale_spd * global.deltaTime);
            if (xscale == 1.6)
            {
                Anim_state = -1.1;
            }
            break;
        case -1.1:
            scale_spd = scr_Approach(scale_spd, 0.2, 0.04 * global.deltaTime);
            xscale = scr_Approach(xscale, 0.3, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 0.3, scale_spd * global.deltaTime);
            if (xscale == 0.3)
            {
                instance_destroy();
            }
            break;
        case 0.1:
            counter += 1;
            if (counter >= counter_max)
            {
                counter = 0;
                Visible = 1;
                Anim_state = 0.2;
            }
            break;
        case 0.2:
            scale_spd = scr_Approach(scale_spd, 0.14, 0.012 * global.deltaTime);
            xscale = scr_Approach(xscale, 1.44, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 1.44, scale_spd * global.deltaTime);
            if (xscale == 1.44)
            {
                target_scale = 1;
                scale_spd = scale_spdMax;
                Anim_state = 1.2;
            }
            break;
        case 1:
            yscale = 0.94;
            xscale = 0.94;
            target_scale = random_range(1.14, 1.2);
            var var_side = choose(-1, 1);
            if (var_side == -1)
            {
                target_rotate = irandom_range(-16, -8);
            }
            else if (var_side == 1)
            {
                target_rotate = irandom_range(8, 16);
            }
            scale_spd = 0.02;
            rotate_spd = 1;
            Anim_state = 1.1;
            break;
        case 1.1:
            scale_spd = scr_Approach(scale_spd, scale_spdMax, 0.01 * global.deltaTime);
            xscale = scr_Approach(xscale, target_scale, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            rotate_spd = scr_Approach(rotate_spd, rotate_spdMax, 0.4);
            rotate = scr_Approach(rotate, target_rotate, rotate_spd);
            if (yscale == target_scale)
            {
                target_rotate = scr_Approach(target_rotate, 0, irandom_range(4, 8));
                target_rotate *= -1;
                Anim_state = 1.2;
            }
            break;
        case 1.2:
            scale_spd = scr_Approach(scale_spd, 0.06, 0.008 * global.deltaTime);
            xscale = scr_Approach(xscale, 1, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 1, scale_spd * global.deltaTime);
            rotate_spd = scr_Approach(rotate_spd, 2, 0.4);
            rotate = scr_Approach(rotate, 0, rotate_spd);
            if (yscale == target_scale)
            {
                scale_spdMax = 0.08;
                scale_spd = scale_spdMax;
                Anim_state = 0;
            }
            break;
    }
}
else if (global.Game_Pause == 1)
{
}
