if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
    {
        if (subimg == 0)
        {
            audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
        }
        subimg = 1;
        shift_y = -1;
        if (global.Lmouse_pressed)
        {
            audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            shift_y = 0;
            Open_list = 1;
        }
    }
    else
    {
        subimg = 0;
        shift_y = 0;
    }
    if (Open_list == 1)
    {
        global.Game_Pause = 1;
        Selected = 1;
        with (obj_Button_Option)
        {
            depth = layer_get_depth("UI") - 2;
        }
        ini_open(global.lang_file);
        var var_points = ini_read_string("Mechanics_text", "Points_text", "");
        var var_mult = ini_read_string("Mechanics_text", "Mult_text", "");
        var var_pair = ini_read_string("Mechanics_text", "Pair_title", "") + ini_read_string("Mechanics_text", "Pair_body", "");
        var var_triple = ini_read_string("Mechanics_text", "Triple_title", "") + ini_read_string("Mechanics_text", "Triple_body", "");
        var var_same4 = ini_read_string("Mechanics_text", "4kind_title", "") + ini_read_string("Mechanics_text", "4kind_body", "");
        var var_same5 = ini_read_string("Mechanics_text", "5kind_title", "") + ini_read_string("Mechanics_text", "5kind_body", "");
        var var_same6 = ini_read_string("Mechanics_text", "6kind_title", "") + ini_read_string("Mechanics_text", "6kind_body", "");
        var var_alldif = ini_read_string("Mechanics_text", "Alldif_title", "") + ini_read_string("Mechanics_text", "Alldif_body", "");
        var var_blackjack = ini_read_string("Mechanics_text", "Blackjack_title", "") + ini_read_string("Mechanics_text", "Blackjack_body", "");
        var var_lowroll = ini_read_string("Mechanics_text", "Lowroll_title", "") + ini_read_string("Mechanics_text", "Lowroll_body", "");
        var var_highroll = ini_read_string("Mechanics_text", "Highroll_title", "") + ini_read_string("Mechanics_text", "Highroll_body", "");
        var var_straight = ini_read_string("Mechanics_text", "Straight_title", "") + ini_read_string("Mechanics_text", "Straight_body", "");
        var var_empty = ini_read_string("Mechanics_text", "Empty_title", "") + ini_read_string("Mechanics_text", "Empty_body", "");
        ini_close();
        var var_y = 0;
        with (instance_create_layer(x, y, "UI", obj_Display_draw))
        {
            Master = other.id;
            Display_type = 0;
        }
        if (!ds_list_empty(global_Level.List_bonus))
        {
            for (var var_i = 0; var_i < ds_list_size(global_Level.List_bonus); var_i += 1)
            {
                var var_bonus = ds_list_find_value(global_Level.List_bonus, var_i);
                switch (var_bonus[0])
                {
                    case "Pair":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_pair_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_pair_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_pair;
                            Text2 = var1 + string(global.Bonus_pair_chips) + " " + var_points + ", " + var2 + string(global.Bonus_pair_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Triple":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_same3_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_same3_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_triple;
                            Text2 = var1 + string(global.Bonus_same3_chips) + " " + var_points + ", " + var2 + string(global.Bonus_same3_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "4Kind":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_same4_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_same4_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_same4;
                            Text2 = var1 + string(global.Bonus_same4_chips) + " " + var_points + ", " + var2 + string(global.Bonus_same4_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "5Kind":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_same5_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_same5_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_same5;
                            Text2 = var1 + string(global.Bonus_same5_chips) + " " + var_points + ", " + var2 + string(global.Bonus_same5_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "6Kind":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_same6_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_same6_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_same6;
                            Text2 = var1 + string(global.Bonus_same6_chips) + " " + var_points + ", " + var2 + string(global.Bonus_same6_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Distinct":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_dif6_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_dif6_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_alldif;
                            Text2 = var1 + string(global.Bonus_dif6_chips) + " " + var_points + ", " + var2 + string(global.Bonus_dif6_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Blackjack":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_21_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_21_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_blackjack;
                            Text2 = var1 + string(global.Bonus_21_chips) + " " + var_points + ", " + var2 + string(global.Bonus_21_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Lowroll":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_lowroll_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_lowroll_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_lowroll;
                            Text2 = var1 + string(global.Bonus_lowroll_chips) + " " + var_points + ", " + var2 + string(global.Bonus_lowroll_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Highroll":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_highroll_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_highroll_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_highroll;
                            Text2 = var1 + string(global.Bonus_highroll_chips) + " " + var_points + ", " + var2 + string(global.Bonus_highroll_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Straight":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_straight_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_straight_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_straight;
                            Text2 = var1 + string(global.Bonus_straight_chips) + " " + var_points + ", " + var2 + string(global.Bonus_straight_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                    case "Empty":
                        with (instance_create_layer(75, 32 + (var_y * 28), "UI", obj_Display_Bonus))
                        {
                            Master = other.id;
                            Bonus_type = var_bonus[0];
                            Bonus_num = var_i;
                            var var1 = "+";
                            if (global.Bonus_empty_chips <= 0)
                            {
                                var1 = "";
                            }
                            var var2 = "+";
                            if (global.Bonus_empty_mult <= 0)
                            {
                                var2 = "";
                            }
                            Text = var_empty;
                            Text2 = var1 + string(global.Bonus_empty_chips) + " " + var_points + ", " + var2 + string(global.Bonus_empty_mult) + " " + var_mult;
                            if (var_bonus[3] == -1)
                            {
                                Nullified = 1;
                                subimg = 2;
                            }
                        }
                        var_y += 1;
                        break;
                }
            }
        }
        Open_list = 0;
    }
}
else if (global.Game_Pause == 1)
{
    if (Selected == 1)
    {
        if (global.Escape)
        {
            Selected = 0;
            Open_by = -4;
            Open_num = -4;
            exit;
        }
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
        {
            if (subimg == 0)
            {
                audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
            }
            subimg = 1;
            shift_y = -1;
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                shift_y = 0;
                global.Game_Pause = 0;
                Selected = 0;
                Open_by = -4;
                Open_num = -4;
                with (obj_Button_Option)
                {
                    depth = layer_get_depth("Base");
                }
            }
        }
        else
        {
            subimg = 0;
            shift_y = 0;
        }
    }
}
