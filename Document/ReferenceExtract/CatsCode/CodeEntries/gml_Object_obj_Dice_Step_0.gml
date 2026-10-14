if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (xscale > 1)
    {
        xscale += -0.03;
        yscale += -0.03;
    }
    else if (xscale < 1)
    {
        xscale = 1;
        yscale = 1;
    }
    if (value_scale > 0)
    {
        value_scale += -0.033;
    }
    else if (value_scale < 0)
    {
        value_scale = 0;
    }
    switch (Rolling)
    {
        case 0:
            if (global.Phase == "Play")
            {
                if (Press_check == 1)
                {
                    Press_counter += 1;
                    if (abs(x - Press_x) > 0)
                    {
                        Press_counter += floor(abs(x - Press_x) / 2);
                    }
                    if (abs(y - Press_y) > 0)
                    {
                        Press_counter += floor(abs(y - Press_y) / 2);
                    }
                    if (Press_counter >= Press_counterMax)
                    {
                        Press_check = 0;
                        Press_counter = 0;
                    }
                    if (Selected != 1)
                    {
                        Press_check = 0;
                        Press_counter = 0;
                    }
                }
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
                if (Selected == 0)
                {
                    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && obj_Cursor.Holding != "Cat")
                    {
                        if (Moused_over == 0)
                        {
                            audio_play_sound(sfx_Dice_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                            Moused_over = 1;
                            Anim_state = 0.5;
                        }
                        if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Dice_body))
                        {
                            if (array_length(Dice_effect[Dice_face]) > 0)
                            {
                                var var_num = 0;
                                var var_y = 0;
                                draw_set_font(global.font_norm1);
                                for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                                {
                                    var var_text = "";
                                    ini_open(global.lang_file);
                                    switch (Dice_effect[Dice_face][var_i][0])
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
                                            var_exist = 0;
                                            with (obj_UI_Dice_body)
                                            {
                                                if (Text_body == var_cantrip)
                                                {
                                                    var_exist = 1;
                                                }
                                            }
                                            if (var_exist == 0)
                                            {
                                                with (instance_create_layer(x - 26, y + 20 + var_y, "UI", obj_UI_Dice_body))
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
                                            var_exist = 0;
                                            with (obj_UI_Dice_body)
                                            {
                                                if (Text_body == var_cantrip)
                                                {
                                                    var_exist = 1;
                                                }
                                            }
                                            if (var_exist == 0)
                                            {
                                                with (instance_create_layer(x - 26, y + 20 + var_y, "UI", obj_UI_Dice_body))
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
                                    var var_exist = 0;
                                    with (obj_UI_Dice_body)
                                    {
                                        if (Text_body == var_text)
                                        {
                                            var_exist = 1;
                                        }
                                    }
                                    if (var_exist == 0)
                                    {
                                        with (instance_create_layer(x - 26, y + 20 + var_y, "UI", obj_UI_Dice_body))
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
                        if (global.Space_pressed)
                        {
                            if (Dice_tray >= 1)
                            {
                                var var_position = -4;
                                for (var var_i = 0; var_i < 6; var_i += 1)
                                {
                                    with (obj_Position)
                                    {
                                        if (Position == var_i)
                                        {
                                            if (Dice_ID == -4)
                                            {
                                                var_position = id;
                                            }
                                        }
                                    }
                                    if (var_position != -4)
                                    {
                                        var var_ok = 1;
                                        var_ok = scr_Cat_diceplace_check(var_position, id);
                                        if (var_ok == 1)
                                        {
                                            break;
                                        }
                                        else
                                        {
                                            var_position = -4;
                                        }
                                    }
                                }
                                if (var_position != -4)
                                {
                                    audio_play_sound(sfx_Dice_slotin, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                    with (obj_Cursor)
                                    {
                                        Holding = 0;
                                    }
                                    Selected = 0;
                                    x = var_position.x;
                                    y = var_position.y + 20;
                                    xscale = 1.1;
                                    yscale = 1.1;
                                    with (var_position)
                                    {
                                        Dice_ID = other.id;
                                    }
                                    if (Dice_tray > 0)
                                    {
                                        with (obj_Dice_tray)
                                        {
                                            Dice_total -= 1;
                                        }
                                        with (obj_Dice)
                                        {
                                            if (Dice_tray > other.Dice_tray)
                                            {
                                                Dice_tray -= 1;
                                                Rolling = 1.1;
                                                Wait_counter = Wait_counterMax;
                                                Silent = 1;
                                            }
                                        }
                                    }
                                    Dice_tray = -1;
                                    scr_Dice_combo_check(0);
                                }
                                else
                                {
                                    audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                                }
                            }
                            else
                            {
                                with (obj_Position)
                                {
                                    if (Dice_ID == other.id)
                                    {
                                        Dice_ID = -4;
                                    }
                                }
                                Rolling = 1.1;
                                Wait_counter = Wait_counterMax;
                                if (Dice_tray <= -1)
                                {
                                    with (obj_Dice_tray)
                                    {
                                        Dice_total += 1;
                                    }
                                    Dice_tray = obj_Dice_tray.Dice_total;
                                }
                                scr_Dice_combo_check(0);
                            }
                            exit;
                        }
                        scr_Dice_shortcut_mouseover();
                        if (global.Rmouse_pressed)
                        {
                            var var_move_x = 0;
                            for (var var_i = 0; var_i < 6; var_i += 1)
                            {
                                with (instance_create_layer(x + (var_i * 45), y - 42, "Dice", obj_Dice_face))
                                {
                                    Master = other.id;
                                    Dice_face = var_i + 1;
                                    Dice_value = other.Dice_value[var_i + 1];
                                    Dice_effect = other.Dice_effect[var_i + 1];
                                    subimg = Dice_value;
                                    subimg_outline = other.subimg_outline;
                                    if (x > (global.Camera_width - 16))
                                    {
                                        var_move_x += 45;
                                    }
                                }
                            }
                            with (obj_Dice_face)
                            {
                                if (Master == other.id)
                                {
                                    x -= var_move_x;
                                }
                            }
                            with (instance_create_layer(0, 0, "Dice", obj_greyscreen))
                            {
                                Master = other.id;
                            }
                            depth = layer_get_depth("Dice") - 2;
                        }
                        if (global.Lmouse_pressed && !place_meeting(x, y, obj_Dice))
                        {
                            audio_play_sound(sfx_Dice_select, 90, false, global.Ctrl_SFX, 0, 1);
                            Press_check = 1;
                            Press_counter = 0;
                            Press_x = obj_Cursor.x;
                            Press_y = obj_Cursor.y;
                            Selected = 1;
                            Moused_over = 2;
                            with (obj_Cursor)
                            {
                                Holding = "Dice";
                            }
                            if (Dice_tray == -1)
                            {
                                Dice_tray = -2;
                                with (obj_Position)
                                {
                                    if (Dice_ID == other.id)
                                    {
                                        Dice_ID = -4;
                                    }
                                }
                                scr_Dice_combo_check(0);
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
                    x = obj_Cursor.x;
                    y = obj_Cursor.y;
                    if ((global.Lmouse_pressed && Press_check == 1) || global.Rmouse_pressed || global.Space_pressed)
                    {
                        var var_position = -4;
                        for (var var_i = 0; var_i < 6; var_i += 1)
                        {
                            with (obj_Position)
                            {
                                if (Position == var_i)
                                {
                                    if (Dice_ID == -4)
                                    {
                                        var_position = id;
                                    }
                                }
                            }
                            if (var_position != -4)
                            {
                                var var_ok = 1;
                                var_ok = scr_Cat_diceplace_check(var_position, id);
                                if (var_ok == 1)
                                {
                                    break;
                                }
                                else
                                {
                                    var_position = -4;
                                }
                            }
                        }
                        if (var_position != -4)
                        {
                            audio_play_sound(sfx_Dice_slotin, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            with (obj_Cursor)
                            {
                                Holding = 0;
                            }
                            Selected = 0;
                            x = var_position.x;
                            y = var_position.y + 20;
                            xscale = 1.1;
                            yscale = 1.1;
                            with (var_position)
                            {
                                Dice_ID = other.id;
                            }
                            if (Dice_tray > 0)
                            {
                                with (obj_Dice_tray)
                                {
                                    Dice_total -= 1;
                                }
                                with (obj_Dice)
                                {
                                    if (Dice_tray > other.Dice_tray)
                                    {
                                        Dice_tray -= 1;
                                        Rolling = 1.1;
                                        Wait_counter = Wait_counterMax;
                                        Silent = 1;
                                    }
                                }
                            }
                            Dice_tray = -1;
                            scr_Dice_combo_check(0);
                        }
                        else
                        {
                            audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                        }
                        exit;
                    }
                    scr_Dice_shortcut_mouseover();
                    if (!position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Position))
                    {
                        if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            var var_dice = -4;
                            if (place_meeting(x, y, obj_Dice))
                            {
                                with (obj_Dice)
                                {
                                    if (id != other.id)
                                    {
                                        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                                        {
                                            var_dice = id;
                                        }
                                    }
                                }
                            }
                            if (var_dice == -4)
                            {
                                Selected = 0;
                                Rolling = 1.1;
                                Wait_counter = Wait_counterMax;
                                if (Dice_tray <= -1)
                                {
                                    with (obj_Dice_tray)
                                    {
                                        Dice_total += 1;
                                    }
                                    Dice_tray = obj_Dice_tray.Dice_total;
                                }
                                with (obj_Cursor)
                                {
                                    Holding = 0;
                                }
                            }
                            else
                            {
                                Selected = 0;
                                Rolling = 1.2;
                                var var_tray = Dice_tray;
                                Dice_tray = var_dice.Dice_tray;
                                x = var_dice.x;
                                y = var_dice.y;
                                with (var_dice)
                                {
                                    Selected = 1.1;
                                    Moused_over = 2;
                                    Dice_tray = var_tray;
                                }
                                with (obj_Cursor)
                                {
                                    Holding = "Dice";
                                }
                            }
                        }
                    }
                    else if (global.Lmouse_pressed || Hold_check == 11)
                    {
                        var var_position = instance_position(obj_Cursor.x, obj_Cursor.y, obj_Position);
                        if (point_in_rectangle(obj_Cursor.x, obj_Cursor.y, var_position.x - 32, var_position.y - 8, var_position.x + 32, var_position.y + 56))
                        {
                            var var_ok = 1;
                            var_ok = scr_Cat_diceplace_check(var_position, id);
                            if (var_ok == 1)
                            {
                                audio_play_sound(sfx_Dice_slotin, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                Selected = 0;
                                Moused_over = -1;
                                x = var_position.x;
                                y = var_position.y + 20;
                                xscale = 1.1;
                                yscale = 1.1;
                                if (place_meeting(x, y, obj_Dice))
                                {
                                    var var_dice = instance_place(x, y, obj_Dice);
                                    with (var_dice)
                                    {
                                        Dice_tray = -2;
                                        Selected = 1.1;
                                        Moused_over = 2;
                                    }
                                }
                                else
                                {
                                    with (obj_Cursor)
                                    {
                                        Holding = 0;
                                    }
                                }
                                with (var_position)
                                {
                                    Dice_ID = other.id;
                                }
                                if (Dice_tray > 0)
                                {
                                    with (obj_Dice_tray)
                                    {
                                        Dice_total -= 1;
                                    }
                                    with (obj_Dice)
                                    {
                                        if (Dice_tray > other.Dice_tray)
                                        {
                                            Dice_tray -= 1;
                                            Rolling = 1.1;
                                            Wait_counter = Wait_counterMax;
                                            Silent = 1;
                                        }
                                    }
                                }
                                Dice_tray = -1;
                                scr_Dice_combo_check(0);
                            }
                            else
                            {
                                audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                            }
                        }
                        else
                        {
                            Selected = 0;
                            Rolling = 1.1;
                            Wait_counter = Wait_counterMax;
                            if (Dice_tray <= -1)
                            {
                                with (obj_Dice_tray)
                                {
                                    Dice_total += 1;
                                }
                                Dice_tray = obj_Dice_tray.Dice_total;
                            }
                            with (obj_Cursor)
                            {
                                Holding = 0;
                            }
                        }
                    }
                }
                else if (Selected == 1.1)
                {
                    Selected = 1;
                }
            }
            else if (global.Phase == "Score")
            {
                if (Score_check == 1)
                {
                    global.Chips += Dice_value[Dice_face];
                    global.Dice_value = Dice_value[Dice_face];
                    var var_display = Dice_value[Dice_face];
                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 10148396;
                    }
                    Score_num += 1;
                    Anim_state = 1;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "<>":
                                    var var_points = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Chips += global.Bling_points;
                                        var_points += global.Bling_points;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    var_display = var_points;
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "+" + string(var_display);
                                        Text_color = 10148396;
                                    }
                                    break;
                                case "M":
                                    var var_mult = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Mult += Dice_value[Dice_face];
                                        var_mult += Dice_value[Dice_face];
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    var_display = var_mult;
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "+" + string(var_display);
                                        Text_color = 5263871;
                                    }
                                    break;
                                case "$":
                                    var var_money = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Player_gold += 1;
                                        var_money += 1;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    var_display = var_money;
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "$" + string(var_display);
                                        Text_color = 5234162;
                                    }
                                    break;
                                case "R":
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Round_reroll += 1;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "+R";
                                        Text_color = 10787638;
                                    }
                                    break;
                                case "^R":
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Round_reroll += 1;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "+R";
                                        Text_color = 10787638;
                                    }
                                    break;
                                case "^Add":
                                    var var_mult = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Mult += 1;
                                        var_mult += 1;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "+" + string(var_mult);
                                        Text_color = 5263871;
                                    }
                                    break;
                                case "Spade":
                                    var var_exist = 0;
                                    var var_total = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        with (obj_Dice)
                                        {
                                            if (Dice_tray == -1 && id != other.id)
                                            {
                                                var var_spade = 0;
                                                var var_value = 0;
                                                if (array_length(Dice_effect[Dice_face]) > 0)
                                                {
                                                    for (var var_j = 0; var_j < array_length(Dice_effect[Dice_face]); var_j += 1)
                                                    {
                                                        switch (Dice_effect[Dice_face][var_j][0])
                                                        {
                                                            case "Spade":
                                                                var_spade = 1;
                                                                break;
                                                            case "<>":
                                                                repeat (Dice_effect[Dice_face][var_j][1])
                                                                {
                                                                    var_value += global.Bling_points;
                                                                }
                                                                break;
                                                        }
                                                    }
                                                }
                                                if (var_spade == 1)
                                                {
                                                    var_total += (Dice_value[Dice_face] + var_value);
                                                    var_exist += 1;
                                                }
                                            }
                                        }
                                    }
                                    if (var_exist > 0)
                                    {
                                        global.Chips += var_total;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                        var_display = var_total;
                                        with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                        {
                                            Master = other.id;
                                            Text = "+" + string(var_display);
                                            Text_color = 10148396;
                                        }
                                    }
                                    break;
                                case "Heart":
                                    var var_exist = 0;
                                    var var_total = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        with (obj_Dice)
                                        {
                                            if (Dice_tray == -1 && id != other.id)
                                            {
                                                var var_heart = 0;
                                                var var_value = 0;
                                                if (array_length(Dice_effect[Dice_face]) > 0)
                                                {
                                                    for (var var_j = 0; var_j < array_length(Dice_effect[Dice_face]); var_j += 1)
                                                    {
                                                        switch (Dice_effect[Dice_face][var_j][0])
                                                        {
                                                            case "Heart":
                                                                var_heart = 1;
                                                                break;
                                                            case "<>":
                                                                repeat (Dice_effect[Dice_face][var_j][1])
                                                                {
                                                                    var_value += global.Bling_points;
                                                                }
                                                                break;
                                                        }
                                                    }
                                                }
                                                if (var_heart == 1)
                                                {
                                                    var_total += (Dice_value[Dice_face] + var_value);
                                                    var_exist += 1;
                                                }
                                            }
                                        }
                                    }
                                    if (var_exist > 0)
                                    {
                                        global.Chips += var_total;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                        var_display = var_total;
                                        with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                        {
                                            Master = other.id;
                                            Text = "+" + string(var_display);
                                            Text_color = 10148396;
                                        }
                                    }
                                    break;
                                case "Boost":
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        Dice_value[Dice_face] = Dice_value[Dice_face] * 2;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    subimg = Dice_value[Dice_face];
                                    instance_create_layer(x, y, "UI", obj_vfx_diceup);
                                    if (subimg > 6)
                                    {
                                        value_scale = 0.6;
                                    }
                                    else
                                    {
                                        value_scale = 0.25;
                                    }
                                    break;
                                case "D":
                                    var var_check = 0;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                        var_check = 1;
                                        with (instance_create_layer(x, y, "Dice", obj_Dice))
                                        {
                                            Master = other.Master;
                                            scr_Dice_setup(other.id);
                                            Dice_face = other.Dice_face;
                                            with (obj_Dice_tray)
                                            {
                                                Dice_total += 1;
                                            }
                                            Dice_tray = obj_Dice_tray.Dice_total;
                                            var var_x = Dice_tray;
                                            if (var_x > Tray_limit)
                                            {
                                                var_x = ((var_x - 1) % Tray_limit) + 1;
                                            }
                                            var var_y = (Dice_tray - 1) div Tray_limit;
                                            spin = 0;
                                            subimg = Dice_value[Dice_face];
                                            subimg_outline = other.subimg_outline;
                                            Rolling = 1.01;
                                        }
                                        scr_Dice_duplication();
                                    }
                                    if (var_check == 1)
                                    {
                                        Score_check = 1.5;
                                    }
                                    break;
                                case "P+":
                                    var var_cat = -4;
                                    var var_position = instance_place(x, y, obj_Position);
                                    with (var_position)
                                    {
                                        if (place_meeting(x, y, obj_Cat))
                                        {
                                            var_cat = instance_place(x, y, obj_Cat);
                                        }
                                    }
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        if (var_cat != -4)
                                        {
                                            with (var_cat)
                                            {
                                                Passive_increase += 1;
                                            }
                                            scr_Cat_positionplace_check(-4, -4);
                                        }
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    break;
                                case "SS":
                                    if (Dice_SS == 0)
                                    {
                                        if (Dice_value[Dice_face] == global.DicePrevious_value)
                                        {
                                            repeat (Dice_effect[Dice_face][var_i][1])
                                            {
                                                Dice_repeat += 1;
                                                global.Dice_effects += 1;
                                                scr_Dice_effect_check();
                                            }
                                            Dice_SS = 1;
                                        }
                                    }
                                    break;
                                case "X2":
                                    var var_multiply = 1;
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        global.Mult = global.Mult * 2;
                                        var_multiply = var_multiply * 2;
                                        global.Dice_effects += 1;
                                        scr_Dice_effect_check();
                                    }
                                    var_display = var_multiply;
                                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                                    {
                                        Master = other.id;
                                        Text = "x" + string(var_display);
                                        Text_color = 5263871;
                                    }
                                    break;
                            }
                        }
                    }
                    if (Score_check == 1)
                    {
                        Score_check = 2;
                    }
                }
                else if (Score_check == 1.5)
                {
                    var var_check = 0;
                    with (obj_Dice)
                    {
                        if (Rolling != 0)
                        {
                            var_check = 1;
                        }
                    }
                    if (var_check == 0)
                    {
                        Score_check = 2;
                    }
                }
                else if (Score_check == 2)
                {
                    Score_check = 2.1;
                    if (Score_order <= 5)
                    {
                        var var_check = 0;
                        while (var_check == 0 && Score_order <= 5)
                        {
                            with (obj_Cat)
                            {
                                if (Cat_pos == other.Score_order)
                                {
                                    Passive_check = 2;
                                    var_check = 1;
                                }
                            }
                            if (var_check == 0)
                            {
                                Score_order += 1;
                                Score_check = 2;
                            }
                        }
                    }
                    else
                    {
                        var var_position = instance_place(x, y, obj_Position);
                        with (var_position)
                        {
                            Dice_check = 0;
                        }
                        global.DicePrevious_value = global.Dice_value;
                        if (Dice_repeat == 0)
                        {
                            if (Dice_Catagain == 0)
                            {
                                Score_check = 0;
                                Score_order = 0;
                                Dice_SS = 0;
                                global.Dice_value = 0;
                                global.Dice_position = -1;
                                global.Dice_effects = 0;
                                with (obj_Ctrl_Cat)
                                {
                                    Score_order += 1;
                                    Score_start = 1;
                                }
                            }
                            else
                            {
                                Dice_Catagain -= 1;
                                Score_check = 1;
                                Score_order = 0;
                                Dice_SS = 0;
                            }
                        }
                        else
                        {
                            Dice_repeat -= 1;
                            Score_check = 1;
                            Score_order = 0;
                        }
                    }
                }
            }
            break;
        case 1:
            Draw_effect = 0;
            if (Sound_create == 0)
            {
                var var_sound = choose(sfx_Dice_roll1, sfx_Dice_roll2, sfx_Dice_roll3);
                audio_play_sound(var_sound, 70, false, global.Ctrl_SFX, 0, random_range(0.92, 1.16));
                Sound_create = 1;
            }
            if ((x < 32 || x > (room_width - 32) || y < 32 || y > (room_height - 32)) || place_meeting(x, y, obj_Dice))
            {
                spd = scr_Approach(spd, 0, 0.84 * global.deltaTime);
                Fric += 0.02;
                if (place_meeting(x, y, obj_Dice))
                {
                    spd *= 0.9;
                }
                var var_chance = choose(-1, 1);
                var var_rotate = irandom_range(2, 12);
                Roll_dir += (180 + (var_chance * var_rotate));
                if (Roll_dir >= 360)
                {
                    Roll_dir -= 360;
                }
                vx = cos(degtorad(Roll_dir)) * spd;
                vy = sin(degtorad(Roll_dir)) * -spd;
                x += vx;
                y += vy;
            }
            spin = scr_Approach(spin, 0, 0.24 * global.deltaTime);
            rotate += (spin * global.deltaTime);
            if (rotate >= 360)
            {
                rotate -= 360;
            }
            if (spin < 12)
            {
                subimg = Dice_value[Dice_face];
            }
            else
            {
                face_change += 1;
                if (face_change == 3)
                {
                    subimg = Dice_value[irandom_range(1, 6)];
                    face_change = 0;
                }
            }
            spd = scr_Approach(spd, 0, 0.42 * global.deltaTime);
            vx = scr_Approach(vx, 0, Fric * global.deltaTime);
            vy = scr_Approach(vy, 0, Fric * global.deltaTime);
            x += (vx * global.deltaTime);
            y += (vy * global.deltaTime);
            if (vx == 0 && vy == 0)
            {
                Rolling = 1.1;
                subimg = Dice_value[Dice_face];
                scr_Dice_roll_check(Dice_value[Dice_face]);
                Sound_create = 0;
            }
            break;
        case 1.01:
            depth = layer_get_depth("Dice") - 2;
            spin = scr_Approach(spin, 0, 0.64 * global.deltaTime);
            rotate += (spin * global.deltaTime);
            if (rotate >= 360)
            {
                rotate -= 360;
            }
            if (spin <= 7.2)
            {
                depth = layer_get_depth("Dice");
                Rolling = 1.2;
                subimg = Dice_value[Dice_face];
                scr_Dice_roll_check(Dice_value[Dice_face]);
                var var_x = Dice_tray;
                if (var_x > Tray_limit)
                {
                    var_x = ((var_x - 1) % Tray_limit) + 1;
                }
                var var_y = (Dice_tray - 1) div Tray_limit;
                var var_FinX = obj_Dice_tray.x + 16 + 20 + ((var_x - 1) * 45);
                var var_FinY = obj_Dice_tray.y + 6 + 16 + (var_y * 35);
                Roll_dir = point_direction(x, y, var_FinX, var_FinY);
            }
            break;
        case 1.05:
            if (Sound_create == 0)
            {
                var var_sound = choose(sfx_Dice_shake1, sfx_Dice_shake2, sfx_Dice_shake3);
                if (audio_is_playing(var_sound))
                {
                    if (!audio_is_playing(sfx_Dice_shake2))
                    {
                        audio_play_sound(sfx_Dice_shake2, 70, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    }
                    else if (!audio_is_playing(sfx_Dice_shake1))
                    {
                        audio_play_sound(sfx_Dice_shake1, 70, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    }
                    else if (!audio_is_playing(sfx_Dice_shake3))
                    {
                        audio_play_sound(sfx_Dice_shake3, 70, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    }
                }
                else
                {
                    audio_play_sound(var_sound, 70, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                }
                Sound_create = 1;
            }
            Draw_effect = 0;
            spin = scr_Approach(spin, 0, 0.64 * global.deltaTime);
            rotate += (spin * global.deltaTime);
            if (rotate >= 360)
            {
                rotate -= 360;
            }
            if (spin < 8)
            {
                subimg = Dice_value[Dice_face];
            }
            else
            {
                face_change += 1;
                if (face_change == 5)
                {
                    subimg = Dice_value[irandom_range(1, 6)];
                    face_change = 0;
                }
            }
            if (spin <= 1.8)
            {
                Rolling = 1.2;
                subimg = Dice_value[Dice_face];
                scr_Dice_roll_check(Dice_value[Dice_face]);
                Sound_create = 0;
                face_change = 0;
            }
            break;
        case 1.1:
            Wait_counter += global.deltaTime;
            if (Wait_counter >= Wait_counterMax)
            {
                if (Silent == 0)
                {
                    audio_play_sound(sfx_Dice_move, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                }
                Rolling = 1.2;
                Wait_counter = 0;
                var var_x = Dice_tray;
                if (var_x > Tray_limit)
                {
                    var_x = ((var_x - 1) % Tray_limit) + 1;
                }
                var var_y = (Dice_tray - 1) div Tray_limit;
                var var_FinX = obj_Dice_tray.x + 16 + 20 + ((var_x - 1) * 45);
                var var_FinY = obj_Dice_tray.y + 6 + 16 + (var_y * 35);
                Roll_dir = point_direction(x, y, var_FinX, var_FinY);
                spd = 10;
                vx = cos(degtorad(Roll_dir)) * spd;
                vy = sin(degtorad(Roll_dir)) * -spd;
            }
            break;
        case 1.2:
            var var_x = Dice_tray;
            if (var_x > Tray_limit)
            {
                var_x = ((var_x - 1) % Tray_limit) + 1;
            }
            var var_y = (Dice_tray - 1) div Tray_limit;
            var var_FinX = obj_Dice_tray.x + 16 + 20 + ((var_x - 1) * 45);
            var var_FinY = obj_Dice_tray.y + 6 + 16 + (var_y * 35);
            spd = scr_Approach(spd, spdMax * 3, 2.8 * global.deltaTime);
            vx = cos(degtorad(Roll_dir)) * spd;
            vy = sin(degtorad(Roll_dir)) * -spd;
            rotate = scr_Approach(rotate, 0, 16 * global.deltaTime);
            x = scr_Approach(x, var_FinX, vx * global.deltaTime);
            y = scr_Approach(y, var_FinY, vy * global.deltaTime);
            if (x == var_FinX && y == var_FinY && rotate == 0)
            {
                Rolling = 0;
                xscale = 1.092;
                yscale = 1.092;
                Draw_effect = 1;
                Silent = 0;
                Moused_over = 0;
            }
            break;
    }
}
else if (global.Game_Pause == 1)
{
}
if (global.Game_Pause == 0)
{
    switch (Anim_state)
    {
        case 0.5:
            var var_rotate = irandom_range(6, 9);
            Anim_rotate = choose(-var_rotate, var_rotate);
            target_scale = random_range(0.92, 0.96);
            Anim_state = 0.6;
            break;
        case 0.6:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.01 * global.deltaTime);
            xscale = scr_Approach(xscale, target_scale, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            rotate_spd = scr_Approach(rotate_spd, 1, 0.3 * global.deltaTime);
            rotate = scr_Approach(rotate, Anim_rotate, rotate_spd * global.deltaTime);
            if (rotate == Anim_rotate)
            {
                Anim_rotate = (Anim_rotate * -1) - (sign(Anim_rotate) * irandom_range(-1, -2));
                target_scale = random_range(1.072, 1.076);
                rotate_spd = rotate_spdMax;
                scale_spd = scale_spdMax;
                Anim_state = 1.2;
            }
            break;
        case 1:
            var var_rotate = irandom_range(10, 12);
            Anim_rotate = choose(-var_rotate, var_rotate);
            target_scale = random_range(0.72, 0.78);
            Anim_state = 1.1;
            break;
        case 1.1:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.01 * global.deltaTime);
            xscale = scr_Approach(xscale, target_scale, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            rotate_spd = scr_Approach(rotate_spd, 1, 0.3 * global.deltaTime);
            rotate = scr_Approach(rotate, Anim_rotate, rotate_spd * global.deltaTime);
            if (rotate == Anim_rotate)
            {
                Anim_rotate = (Anim_rotate * -1) - (sign(Anim_rotate) * irandom_range(-1, -2));
                target_scale = random_range(1.138, 1.148);
                rotate_spd = rotate_spdMax;
                scale_spd = scale_spdMax;
                Anim_state = 1.2;
            }
            break;
        case 1.2:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.007 * global.deltaTime);
            xscale = scr_Approach(xscale, target_scale, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            rotate_spd = scr_Approach(rotate_spd, 1, 0.3 * global.deltaTime);
            rotate = scr_Approach(rotate, Anim_rotate, rotate_spd * global.deltaTime);
            if (rotate == Anim_rotate)
            {
                rotate_spd = rotate_spdMax;
                Anim_rotate = 0;
                target_scale = 1;
                Anim_state = 1.3;
            }
            break;
        case 1.3:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.01 * global.deltaTime);
            xscale = scr_Approach(xscale, target_scale, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            rotate_spd = scr_Approach(rotate_spd, 1, 0.3 * global.deltaTime);
            rotate = scr_Approach(rotate, 0, rotate_spd * global.deltaTime);
            if (rotate == 0 && xscale == 1 && yscale == 1)
            {
                rotate_spd = rotate_spdMax;
                scale_spd = scale_spdMax;
                Anim_state = 0;
            }
            break;
    }
}
