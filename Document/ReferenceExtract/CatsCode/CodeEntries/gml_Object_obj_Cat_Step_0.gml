if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (Dice_create == 1)
    {
        with (instance_create_layer(x, y, "Dice", obj_Dice))
        {
            Master = other.id;
            scr_Dice_setup(Master);
            Dice_face = choose(1, 2, 3, 4, 5, 6);
            with (obj_Dice_tray)
            {
                Dice_total += 1;
            }
            Dice_tray = obj_Dice_tray.Dice_total;
            for (var var_i = 0; var_i < other.Passive_max; var_i += 1)
            {
                switch (other.Passive[var_i])
                {
                    case UnknownEnum.Value_25:
                        Dice_face = other.Cat_pos + 1;
                        break;
                    case UnknownEnum.Value_1023:
                        Dice_face = 1;
                        break;
                    case UnknownEnum.Value_1024:
                        Dice_face = 2;
                        break;
                    case UnknownEnum.Value_1025:
                        Dice_face = 3;
                        break;
                    case UnknownEnum.Value_1026:
                        Dice_face = 4;
                        break;
                    case UnknownEnum.Value_1027:
                        Dice_face = 5;
                        break;
                    case UnknownEnum.Value_1028:
                        Dice_face = 6;
                        break;
                }
            }
            Roll_dir = irandom_range(0, 359);
            spd = random_range(spdMin, spdMax);
            vx = cos(degtorad(Roll_dir)) * spd;
            vy = sin(degtorad(Roll_dir)) * -spd;
            rotate = irandom_range(0, 359);
            subimg = Dice_value[irandom_range(0, 5)];
            subimg_outline = other.Cat_pos + 1;
        }
        Dice_create = 0;
    }
    if (Shop_created == 0 && global.Cat_lock == 0)
    {
        if (global.Phase == "Round_won" || global.Phase == "Round_won_display")
        {
            if (jump_counter >= jump_counterMax)
            {
                if (Anim_state == -1)
                {
                    Anim_state = 1;
                    float_y = 2;
                    float_spd = random_range(-0.92, -0.88);
                }
                float_y += float_spd;
                float_spd = scr_Approach(float_spd, 0.8, 0.05);
                if (float_y >= 2)
                {
                    float_y = 2;
                    jump_counter = 0;
                    jump_counterMax = irandom_range(2, 8);
                    Anim_state = 1;
                    float_spd = random_range(-0.92, -0.88);
                }
            }
            else
            {
                jump_counter += 1;
            }
        }
        else if (global.Phase != "Score" && global.Phase != "Score_wait" && global.Phase != "Score_display" && global.Phase != "Score_check")
        {
            if (Selected != 1)
            {
                if (float_stop == 0)
                {
                    float_spd = scr_Approach(float_spd, 0.042, 0.0024);
                    float_y = scr_Approach(float_y, float_yMax, float_spd);
                    if (float_y == float_yMax)
                    {
                        var var_new = choose(1.2, 1.5, 1.8, 2.1);
                        if (float_yMax == 0)
                        {
                            float_yMax = 1;
                        }
                        float_yMax = sign(float_yMax) * -1 * var_new;
                        float_stop = irandom_range(2, 4);
                    }
                }
                else
                {
                    float_spd = scr_Approach(float_spd, 0, 0.02);
                    float_y += (sign(float_y) * float_spd);
                    float_stop = scr_Approach(float_stop, 0, 1);
                    if (float_stop == 0)
                    {
                        float_spd = 0;
                    }
                }
                float_x = scr_Approach(float_x, float_xMax, 0.024);
                if (float_x == float_xMax)
                {
                    float_xMax = choose(-1.4, 0, 1.4);
                }
            }
        }
    }
    switch (global.Phase)
    {
        case "Play":
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
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && !place_meeting(x, y, obj_Dice))
                {
                    if (Moused_over == 0)
                    {
                        audio_play_sound(sfx_Cat_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                        Moused_over = 1;
                        Anim_state = 1;
                    }
                    float_x = scr_Approach(float_x, 0, 0.6);
                    float_y = scr_Approach(float_y, 1, 0.8);
                    float_xMax = 0;
                    float_yMax = 0;
                    if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                    {
                        var var_create = 0;
                        for (var var_i = 0; var_i < Passive_max; var_i += 1)
                        {
                            if (Passive[var_i] != -4 && Passive_skip[var_i] != 1)
                            {
                                with (instance_create_layer(x - 86, y + 2 + var_create, "UI", obj_UI_Cat_body))
                                {
                                    Master = other.id;
                                    Text_body = other.Text_Passive[var_i];
                                    Cat_num = other.Cat_num[var_i];
                                    Cat_chips = other.Cat_chips[var_i];
                                    Cat_mult = other.Cat_mult[var_i];
                                    Round_chips = other.Round_chips[var_i];
                                    Round_mult = other.Round_mult[var_i];
                                    draw_set_font(global.font_norm1);
                                    var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                                    if (var_lines == 0)
                                    {
                                        currentspr = spr_UI_Cat_body;
                                        var_create += 17;
                                    }
                                    else if (var_lines == 1)
                                    {
                                        currentspr = spr_UI_Cat_body2;
                                        var_create += 30;
                                    }
                                    else if (var_lines == 2)
                                    {
                                        currentspr = spr_UI_Cat_body3;
                                        var_create += 42;
                                    }
                                    else if (var_lines >= 3)
                                    {
                                        currentspr = spr_UI_Cat_body3;
                                        var_create += 42;
                                    }
                                    draw_set_font(global.font_big1);
                                }
                            }
                        }
                        if (var_create == 0)
                        {
                            with (instance_create_layer(x - 86, y + 2, "UI", obj_UI_Cat_body))
                            {
                                Master = other.id;
                                ini_open(global.lang_file);
                                Text_body = ini_read_string("Cat_text", "None_passive", "");
                                ini_close();
                            }
                        }
                        with (instance_create_layer(x, y - 96, "UI", obj_UI_Cat_head))
                        {
                            Master = other.id;
                            Text_head = other.Text_Cat;
                        }
                    }
                    if (global.Lmouse_pressed)
                    {
                        if (global.Cat_lock == 0)
                        {
                            audio_play_sound(sfx_Cat_select, 90, false, global.Ctrl_SFX, 0, 1);
                            Anim_state = 1;
                            Hold_check = 1;
                            Selected = 1;
                            depth = layer_get_depth("Dice") - 2;
                            scr_Cat_positionplace_check(-4, -4);
                            with (obj_Cursor)
                            {
                                Holding = "Cat";
                            }
                            var var_occupy = 0;
                            var var_Cat = id;
                            with (instance_position(x, y, obj_Position))
                            {
                                with (obj_Cat)
                                {
                                    if (id != var_Cat && place_meeting(x, y, other.id))
                                    {
                                        var_occupy = 1;
                                    }
                                }
                                if (var_occupy == 0)
                                {
                                    Occupied = 0;
                                    subimg = 0;
                                }
                            }
                            with (obj_Dice)
                            {
                                if (Master == other.id)
                                {
                                    subimg_outline = 0;
                                }
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
            else if (Selected == 0.9)
            {
                Selected = 1;
            }
            else if (Selected == 1)
            {
                x = obj_Cursor.x;
                y = obj_Cursor.y + 40;
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Position))
                {
                    if (global.Lmouse_pressed || Hold_check == 11)
                    {
                        audio_play_sound(sfx_Cat_place, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                        var var_Pos = instance_position(obj_Cursor.x, obj_Cursor.y, obj_Position);
                        x = var_Pos.x;
                        y = var_Pos.y;
                        Selected = 0;
                        depth = layer_get_depth("Cat");
                        if (place_meeting(x, y, obj_Cat))
                        {
                            var var_oldpos = Cat_pos;
                            var var_Cat = instance_place(x, y, obj_Cat);
                            if (Cat_pos != var_Cat.Cat_pos)
                            {
                                Cat_moved += 1;
                            }
                            Cat_pos = var_Cat.Cat_pos;
                            with (var_Cat)
                            {
                                Cat_pos = var_oldpos;
                                Selected = 0.9;
                                depth = layer_get_depth("Dice") - 2;
                            }
                            with (obj_Dice)
                            {
                                if (Master == other.id)
                                {
                                    subimg_outline = other.Cat_pos + 1;
                                }
                            }
                        }
                        else
                        {
                            if (Cat_pos != var_Pos.Position)
                            {
                                Cat_moved += 1;
                            }
                            Cat_pos = var_Pos.Position;
                            with (obj_Cursor)
                            {
                                Holding = 0;
                            }
                            with (var_Pos)
                            {
                                Occupied = 1;
                                subimg = Position + 1;
                            }
                            with (obj_Dice)
                            {
                                if (Master == other.id)
                                {
                                    subimg_outline = other.Cat_pos + 1;
                                }
                            }
                        }
                        scr_Cat_positionplace_check(var_Pos, var_Pos.Dice_ID);
                    }
                }
                else if (global.Lmouse_pressed || Hold_check == 11)
                {
                    Selected = 0;
                    depth = layer_get_depth("Cat");
                    var var_x = 0;
                    var var_y = 0;
                    var var_Pos = -4;
                    with (obj_Position)
                    {
                        if (Position == other.Cat_pos)
                        {
                            var_x = x;
                            var_y = y;
                            var_Pos = id;
                            Occupied = 1;
                            subimg = Position + 1;
                        }
                    }
                    x = var_x;
                    y = var_y;
                    with (obj_Dice)
                    {
                        if (Master == other.id)
                        {
                            subimg_outline = other.Cat_pos + 1;
                        }
                    }
                    scr_Cat_positionplace_check(var_Pos, var_Pos.Dice_ID);
                    with (obj_Cursor)
                    {
                        wait_counter = 1;
                    }
                }
            }
            break;
        case "BoonBane":
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
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (Moused_over == 0)
                    {
                        audio_play_sound(sfx_Cat_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                        Moused_over = 1;
                        Anim_state = 1;
                    }
                    float_x = scr_Approach(float_x, 0, 0.6);
                    float_y = scr_Approach(float_y, 1, 0.8);
                    float_xMax = 0;
                    float_yMax = 0;
                    if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                    {
                        var var_create = 0;
                        for (var var_i = 0; var_i < Passive_max; var_i += 1)
                        {
                            if (Passive[var_i] != -4 && Passive_skip[var_i] != 1)
                            {
                                with (instance_create_layer(x - 86, y + 2 + var_create, "UI", obj_UI_Cat_body))
                                {
                                    Master = other.id;
                                    Text_body = other.Text_Passive[var_i];
                                    Cat_num = other.Cat_num[var_i];
                                    Cat_chips = other.Cat_chips[var_i];
                                    Cat_mult = other.Cat_mult[var_i];
                                    Round_chips = other.Round_chips[var_i];
                                    Round_mult = other.Round_mult[var_i];
                                    draw_set_font(global.font_norm1);
                                    var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                                    switch (var_lines)
                                    {
                                        case 0:
                                            currentspr = spr_UI_Cat_body;
                                            var_create += 17;
                                            break;
                                        case 1:
                                            currentspr = spr_UI_Cat_body2;
                                            var_create += 30;
                                            break;
                                        case 2:
                                            currentspr = spr_UI_Cat_body3;
                                            var_create += 42;
                                            break;
                                    }
                                    draw_set_font(global.font_big1);
                                }
                            }
                        }
                        if (var_create == 0)
                        {
                            with (instance_create_layer(x - 86, y + 2, "UI", obj_UI_Cat_body))
                            {
                                Master = other.id;
                                ini_open(global.lang_file);
                                Text_body = ini_read_string("Cat_text", "None_passive", "");
                                ini_close();
                            }
                        }
                        with (instance_create_layer(x, y - 96, "UI", obj_UI_Cat_head))
                        {
                            Master = other.id;
                            Text_head = other.Text_Cat;
                        }
                    }
                    if (global.Lmouse_pressed)
                    {
                        audio_play_sound(sfx_Cat_select, 90, false, global.Ctrl_SFX, 0, 1);
                        Anim_state = 1;
                        Hold_check = 1;
                        Selected = 1;
                        depth = layer_get_depth("Dice") - 2;
                        scr_Cat_positionplace_check(-4, -4);
                        with (obj_Cursor)
                        {
                            Holding = "Cat";
                        }
                        var var_occupy = 0;
                        var var_Cat = id;
                        with (instance_position(x, y, obj_Position))
                        {
                            with (obj_Cat)
                            {
                                if (id != var_Cat && place_meeting(x, y, other.id))
                                {
                                    var_occupy = 1;
                                }
                            }
                            if (var_occupy == 0)
                            {
                                Occupied = 0;
                                subimg = 0;
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
            }
            else if (Selected == 1)
            {
                x = obj_Cursor.x;
                y = obj_Cursor.y + 40;
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Position))
                {
                    if (global.Lmouse_pressed || Hold_check == 11)
                    {
                        audio_play_sound(sfx_Cat_place, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                        var var_Pos = instance_position(obj_Cursor.x, obj_Cursor.y, obj_Position);
                        x = var_Pos.x;
                        y = var_Pos.y;
                        Selected = 0;
                        depth = layer_get_depth("Cat");
                        if (place_meeting(x, y, obj_Cat))
                        {
                            var var_oldpos = Cat_pos;
                            var var_Cat = instance_place(x, y, obj_Cat);
                            Cat_pos = var_Cat.Cat_pos;
                            with (var_Cat)
                            {
                                Cat_pos = var_oldpos;
                                Selected = 0.9;
                                depth = layer_get_depth("Dice") - 2;
                            }
                        }
                        else
                        {
                            Cat_pos = var_Pos.Position;
                            with (obj_Cursor)
                            {
                                Holding = 0;
                            }
                            with (var_Pos)
                            {
                                Occupied = 1;
                                subimg = Position + 1;
                            }
                        }
                        scr_Cat_positionplace_check(var_Pos, var_Pos.Dice_ID);
                    }
                }
                else if (global.Lmouse_pressed || Hold_check == 11)
                {
                    Selected = 0;
                    depth = layer_get_depth("Cat");
                    var var_x = 0;
                    var var_y = 0;
                    var var_Pos = -4;
                    with (obj_Position)
                    {
                        if (Position == other.Cat_pos)
                        {
                            var_x = x;
                            var_y = y;
                            var_Pos = id;
                            Occupied = 1;
                            subimg = Position + 1;
                        }
                    }
                    x = var_x;
                    y = var_y;
                    scr_Cat_positionplace_check(-4, -4);
                    with (obj_Cursor)
                    {
                        wait_counter = 1;
                    }
                }
            }
            break;
        case "Score":
            if (Passive_check == 1)
            {
                Passive_check = 0;
                if (Passive_num <= 3)
                {
                    if (Dice_duplication == 1)
                    {
                        var var_trigger = scr_Cat_passive_check(Passive[Passive_num], Passive_num);
                        Passive_num += 1;
                    }
                    while (Passive_num <= 3 && Dice_duplication == 0)
                    {
                        while (Passive[Passive_num] == -4)
                        {
                            Passive_num += 1;
                            if (Passive_num >= 4)
                            {
                                Passive_check = 1;
                                break;
                            }
                        }
                        var var_trigger = scr_Cat_passive_check(Passive[Passive_num], Passive_num);
                        Passive_num += 1;
                        if (var_trigger > 0)
                        {
                            break;
                        }
                    }
                }
                else
                {
                    Passive_num = 0;
                    with (instance_place(x, y, obj_Position))
                    {
                        Cat_check = 0;
                        if (place_meeting(x, y, obj_vfx_scoring))
                        {
                            Dice_check = 0.5;
                        }
                        else
                        {
                            Dice_check = 1;
                        }
                    }
                }
            }
            else if (Passive_check == 2)
            {
                Passive_check = 0;
                if (Passive_num <= 3)
                {
                    if (Dice_duplication == 1)
                    {
                        var var_trigger = scr_Cat_passive_check(Passive[Passive_num], Passive_num);
                        Passive_num += 1;
                    }
                    while (Passive_num <= 3 && Dice_duplication == 0)
                    {
                        while (Passive[Passive_num] == -4)
                        {
                            Passive_num += 1;
                            if (Passive_num >= 4)
                            {
                                Passive_check = 1;
                                break;
                            }
                        }
                        var var_trigger = scr_Cat_dicescore_check(Passive[Passive_num], Passive_num);
                        Passive_num += 1;
                        if (var_trigger > 0)
                        {
                            break;
                        }
                    }
                }
                else
                {
                    Passive_num = 0;
                    with (obj_Dice)
                    {
                        if (Score_check == 2.1)
                        {
                            Score_order += 1;
                            Score_check = 2;
                        }
                    }
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
                    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && obj_Cursor.Holding != "Cat_buy" && obj_Cursor.Holding != "Cat")
                    {
                        if (Moused_over == 0)
                        {
                            audio_play_sound(sfx_Cat_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                            Moused_over = 1;
                            Anim_state = 1;
                        }
                        float_x = scr_Approach(float_x, 0, 0.6);
                        float_y = scr_Approach(float_y, 1, 0.8);
                        float_xMax = 0;
                        float_yMax = 0;
                        if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                        {
                            var var_create = 0;
                            for (var var_i = 0; var_i < Passive_max; var_i += 1)
                            {
                                if (Passive[var_i] != -4 && Passive_skip[var_i] != 1)
                                {
                                    with (instance_create_layer(x - 86, y + 2 + var_create, "UI", obj_UI_Cat_body))
                                    {
                                        Master = other.id;
                                        Text_body = other.Text_Passive[var_i];
                                        Cat_num = other.Cat_num[var_i];
                                        Cat_chips = other.Cat_chips[var_i];
                                        Cat_mult = other.Cat_mult[var_i];
                                        Round_chips = other.Round_chips[var_i];
                                        Round_mult = other.Round_mult[var_i];
                                        draw_set_font(global.font_norm1);
                                        var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                                        switch (var_lines)
                                        {
                                            case 0:
                                                currentspr = spr_UI_Cat_body;
                                                var_create += 17;
                                                break;
                                            case 1:
                                                currentspr = spr_UI_Cat_body2;
                                                var_create += 30;
                                                break;
                                            case 2:
                                                currentspr = spr_UI_Cat_body3;
                                                var_create += 42;
                                                break;
                                        }
                                        draw_set_font(global.font_big1);
                                    }
                                }
                            }
                            if (var_create == 0)
                            {
                                with (instance_create_layer(x - 86, y + 2, "UI", obj_UI_Cat_body))
                                {
                                    Master = other.id;
                                    ini_open(global.lang_file);
                                    Text_body = ini_read_string("Cat_text", "None_passive", "");
                                    ini_close();
                                }
                            }
                            with (instance_create_layer(x, y - 96, "UI", obj_UI_Cat_head))
                            {
                                Master = other.id;
                                Text_head = other.Text_Cat;
                            }
                        }
                        if (global.Lmouse_pressed)
                        {
                            if (!position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Item))
                            {
                                audio_play_sound(sfx_Cat_select, 90, false, global.Ctrl_SFX, 0, 1);
                                Anim_state = 1;
                                Hold_check = 1;
                                Selected = 1;
                                depth = layer_get_depth("Dice") - 2;
                                with (obj_Cursor)
                                {
                                    Holding = "Cat";
                                }
                                scr_Cat_positionplace_check(-4, -4);
                                var var_occupy = 0;
                                var var_Cat = id;
                                with (instance_position(x, y, obj_Position))
                                {
                                    with (obj_Cat)
                                    {
                                        if (id != var_Cat && place_meeting(x, y, other.id))
                                        {
                                            var_occupy = 1;
                                        }
                                    }
                                    if (var_occupy == 0)
                                    {
                                        Occupied = 0;
                                        subimg = 0;
                                    }
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
                }
                else if (Selected == 1)
                {
                    x = obj_Cursor.x;
                    y = obj_Cursor.y + 40;
                    if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Position))
                    {
                        if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            audio_play_sound(sfx_Cat_place, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            var var_Pos = instance_position(obj_Cursor.x, obj_Cursor.y, obj_Position);
                            x = var_Pos.x;
                            y = var_Pos.y;
                            Selected = 0;
                            depth = layer_get_depth("Cat");
                            if (place_meeting(x, y, obj_Cat))
                            {
                                var var_oldpos = Cat_pos;
                                var var_Cat = instance_place(x, y, obj_Cat);
                                Cat_pos = var_Cat.Cat_pos;
                                with (var_Cat)
                                {
                                    Cat_pos = var_oldpos;
                                    Selected = 0.9;
                                    depth = layer_get_depth("Dice") - 2;
                                }
                            }
                            else
                            {
                                Cat_pos = var_Pos.Position;
                                with (obj_Cursor)
                                {
                                    Holding = 0;
                                }
                                with (var_Pos)
                                {
                                    Occupied = 1;
                                    subimg = Position + 1;
                                }
                            }
                            scr_Cat_positionplace_check(var_Pos, -4);
                        }
                    }
                    else if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Dice_tray))
                    {
                        if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            audio_play_sound(sfx_Cat_place, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            audio_play_sound(sfx_UI_money_gain, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            global.Player_gold += ceil(0.5 * Cat_cost);
                            with (obj_Item)
                            {
                                if (place_meeting(x, y, other.id))
                                {
                                    if (Shop_created == 0)
                                    {
                                        global.Player_gold += ceil(0.5 * Item_cost);
                                        instance_destroy();
                                    }
                                }
                            }
                            instance_destroy();
                            with (obj_Cursor)
                            {
                                wait_counter = 1;
                            }
                        }
                    }
                    else if (global.Lmouse_pressed || Hold_check == 11)
                    {
                        if (Cat_pos >= 0)
                        {
                            audio_play_sound(sfx_Cat_move, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            Selected = 0;
                            depth = layer_get_depth("Cat");
                            var var_x = 0;
                            var var_y = 0;
                            var var_Pos = -4;
                            with (obj_Position)
                            {
                                if (Position == other.Cat_pos)
                                {
                                    var_x = x;
                                    var_y = y;
                                    var_Pos = id;
                                    Occupied = 1;
                                    subimg = Position + 1;
                                }
                            }
                            x = var_x;
                            y = var_y;
                            with (obj_Cursor)
                            {
                                wait_counter = 1;
                            }
                            scr_Cat_positionplace_check(var_Pos, -4);
                        }
                        else
                        {
                            var var_Pos = -4;
                            for (var var_i = 0; var_i < 6; var_i += 1)
                            {
                                with (obj_Position)
                                {
                                    if (Position == var_i)
                                    {
                                        if (!place_meeting(x, y, obj_Cat))
                                        {
                                            var_Pos = id;
                                        }
                                    }
                                }
                                if (var_Pos != -4)
                                {
                                    break;
                                }
                            }
                            if (var_Pos != -4)
                            {
                                audio_play_sound(sfx_Cat_move, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                Selected = 0;
                                Cat_pos = var_Pos.Position;
                                depth = layer_get_depth("Cat");
                                x = var_Pos.x;
                                y = var_Pos.y;
                                scr_Cat_positionplace_check(var_Pos, -4);
                                with (var_Pos)
                                {
                                    Occupied = 1;
                                    subimg = Position + 1;
                                }
                                with (obj_Cursor)
                                {
                                    wait_counter = 1;
                                }
                            }
                            else
                            {
                                audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                            }
                        }
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
                                audio_play_sound(sfx_Cat_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.92, 1.06));
                                Moused_over = 1;
                                Anim_state = 1;
                            }
                            if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Cat_body))
                            {
                                with (instance_create_layer(x, y - 96, "UI", obj_UI_Cat_head))
                                {
                                    Master = other.id;
                                    Text_head = other.Text_Cat;
                                }
                                var var_create = 0;
                                for (var var_i = 0; var_i < Passive_max; var_i += 1)
                                {
                                    if (Passive[var_i] != -4 && Passive_skip[var_i] != 1)
                                    {
                                        with (instance_create_layer(x - 86, y - 96 - 52, "UI", obj_UI_Cat_body))
                                        {
                                            Master = other.id;
                                            Text_body = other.Text_Passive[var_i];
                                            Cat_num = other.Cat_num[var_i];
                                            Cat_chips = other.Cat_chips[var_i];
                                            Cat_mult = other.Cat_mult[var_i];
                                            Round_chips = other.Round_chips[var_i];
                                            Round_mult = other.Round_mult[var_i];
                                            draw_set_font(global.font_norm1);
                                            var var_lines = scr_Text_draw(x, y, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
                                            switch (var_lines)
                                            {
                                                case 0:
                                                    currentspr = spr_UI_Cat_body;
                                                    y += 25;
                                                    break;
                                                case 1:
                                                    currentspr = spr_UI_Cat_body2;
                                                    y += 12;
                                                    break;
                                                case 2:
                                                    currentspr = spr_UI_Cat_body3;
                                                    break;
                                            }
                                            draw_set_font(global.font_big1);
                                        }
                                        var_create += 1;
                                    }
                                }
                                if (var_create == 0)
                                {
                                    with (instance_create_layer(x - 86, y - 96 - 52, "UI", obj_UI_Cat_body))
                                    {
                                        Master = other.id;
                                        ini_open(global.lang_file);
                                        Text_body = ini_read_string("Cat_text", "None_passive", "");
                                        ini_close();
                                        y += 25;
                                    }
                                }
                                if (!instance_exists(obj_greyscreen))
                                {
                                    var var_move_x = 0;
                                    var var_y = 13;
                                    for (var var_i = 0; var_i < 6; var_i += 1)
                                    {
                                        with (instance_create_layer((x - 20) + (var_i * 45), y + var_y, "Dice", obj_Dice_face))
                                        {
                                            Shop_cat = 1;
                                            Master = other.id;
                                            Dice_face = var_i + 1;
                                            Dice_value = other.Dice_value[var_i + 1];
                                            Dice_effect = other.Dice_effect[var_i + 1];
                                            subimg = Dice_value;
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
                                }
                            }
                            if (global.Lmouse_pressed)
                            {
                                if (global.Player_gold >= Cat_cost)
                                {
                                    audio_play_sound(sfx_Cat_select, 80, false, global.Ctrl_SFX, 0, 1);
                                    Anim_state = 1;
                                    Hold_check = 1;
                                    Selected = 1;
                                    depth = layer_get_depth("Dice") - 2;
                                    with (obj_Cursor)
                                    {
                                        Holding = "Cat_buy";
                                    }
                                }
                                else
                                {
                                    audio_play_sound(sfx_UI_invalid, 80, false, global.Ctrl_SFX, 0, 1);
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
                        y = obj_Cursor.y + 40;
                        if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Position))
                        {
                            if (global.Lmouse_pressed || Hold_check == 11)
                            {
                                audio_play_sound(sfx_Cat_place, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                audio_play_sound(sfx_UI_money_spent, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                var var_Pos = instance_position(obj_Cursor.x, obj_Cursor.y, obj_Position);
                                x = var_Pos.x;
                                y = var_Pos.y;
                                Selected = 0;
                                Shop_created = 0;
                                depth = layer_get_depth("Cat");
                                global.Player_gold -= Cat_cost;
                                with (global_Level)
                                {
                                    if (Shop_cat[0] == other.Cat_type)
                                    {
                                        Shop_cat[0] = -4;
                                    }
                                    else if (Shop_cat[1] == other.Cat_type)
                                    {
                                        Shop_cat[1] = -4;
                                    }
                                }
                                if (place_meeting(x, y, obj_Cat))
                                {
                                    var var_Cat = instance_place(x, y, obj_Cat);
                                    Cat_pos = var_Cat.Cat_pos;
                                    with (var_Cat)
                                    {
                                        Selected = 1;
                                        Cat_pos = -1;
                                        depth = layer_get_depth("Dice") - 2;
                                    }
                                    with (obj_Cursor)
                                    {
                                        Holding = "Cat";
                                    }
                                }
                                else
                                {
                                    Cat_pos = var_Pos.Position;
                                    with (obj_Cursor)
                                    {
                                        Holding = 0;
                                    }
                                    with (var_Pos)
                                    {
                                        Occupied = 1;
                                        subimg = Position + 1;
                                    }
                                }
                                scr_Cat_positionplace_check(var_Pos, -4);
                            }
                        }
                        else if (global.Lmouse_pressed || Hold_check == 11)
                        {
                            audio_play_sound(sfx_Cat_move, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                            Selected = 0;
                            depth = layer_get_depth("Cat");
                            x = obj_Dice_tray.x + 44 + (Cat_pos * 84);
                            y = obj_Dice_tray.y + 92;
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
}
else if (global.Game_Pause == 1)
{
}
if (global.Game_Pause == 0)
{
    switch (Anim_state)
    {
        case -1:
            scale_spd = scr_Approach(scale_spd, 0.04, 0.008 * global.deltaTime);
            xscale = scr_Approach(xscale, 1.18, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 1.14, scale_spd * global.deltaTime);
            if (xscale == 1.18)
            {
                scale_spd = scale_spdMax;
                Anim_state = -1.1;
            }
            break;
        case -1.1:
            scale_spd = scr_Approach(scale_spd, 0.11, 0.006 * global.deltaTime);
            xscale = scr_Approach(xscale, 0.64, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 0.64, scale_spd * global.deltaTime);
            if (xscale == 0.64)
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
            scale_spd = scr_Approach(scale_spd, 0.02, 0.0016 * global.deltaTime);
            xscale = scr_Approach(xscale, 1.24, scale_spd * global.deltaTime);
            yscale = scr_Approach(yscale, 1.14, scale_spd * global.deltaTime);
            if (xscale == 1.24)
            {
                target_scale = 1;
                Anim_state = 1.3;
            }
            break;
        case 0.9:
            scale_spdMax = 0.08;
            target_scale = random_range(0.86, 0.88);
            yscale = 0.98;
            xscale = 0.98;
            scale_spd = scale_spdMax;
            Anim_state = 1.1;
            break;
        case 1:
            yscale = 0.98;
            xscale = 0.98;
            if (global.Phase == "Score" || global.Phase == "Round_won" || global.Phase == "Round_won_display")
            {
                scale_spdMax = 0.08;
                target_scale = random_range(0.86, 0.88);
            }
            else
            {
                scale_spdMax = 0.004;
                target_scale = 0.964;
            }
            scale_spd = scale_spdMax;
            Anim_state = 1.1;
            break;
        case 1.1:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.01 * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            if (global.Phase == "Score" || global.Phase == "Round_won" || global.Phase == "Round_won_display")
            {
                xscale = scr_Approach(xscale, 0.88, scale_spd * global.deltaTime);
            }
            else
            {
                xscale = scr_Approach(xscale, 0.964, scale_spd * global.deltaTime);
            }
            if (yscale == target_scale)
            {
                if (global.Phase == "Score" || global.Phase == "Round_won" || global.Phase == "Round_won_display")
                {
                    target_scale = random_range(1.1, 1.12);
                }
                else
                {
                    target_scale = 1.02;
                }
                scale_spd = scale_spdMax;
                Anim_state = 1.2;
            }
            break;
        case 1.2:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.007 * global.deltaTime);
            yscale = scr_Approach(yscale, target_scale, scale_spd * global.deltaTime);
            if (global.Phase == "Score" || global.Phase == "Round_won" || global.Phase == "Round_won_display")
            {
                xscale = scr_Approach(xscale, 1.08, scale_spd * global.deltaTime);
            }
            else
            {
                xscale = scr_Approach(xscale, 1, scale_spd * global.deltaTime);
            }
            if (yscale == target_scale)
            {
                target_scale = 1;
                Anim_state = 1.3;
            }
            break;
        case 1.3:
            scale_spd = scr_Approach(scale_spd, 0.02, 0.01 * global.deltaTime);
            yscale = scr_Approach(yscale, 1, scale_spd * global.deltaTime);
            xscale = scr_Approach(xscale, 1, scale_spd * global.deltaTime);
            if (yscale == 1 && xscale == 1)
            {
                scale_spdMax = 0.08;
                scale_spd = scale_spdMax;
                Anim_state = 0;
                if (Anim_delay > 0)
                {
                    Anim_delay -= 1;
                    Anim_state = 1;
                    global.Freeze_frame = 1;
                    with (global_Control)
                    {
                        Freeze_counter = 0;
                    }
                }
            }
            break;
    }
}

enum UnknownEnum
{
    Value_25 = 25,
    Value_1023 = 1023,
    Value_1024,
    Value_1025,
    Value_1026,
    Value_1027,
    Value_1028
}
