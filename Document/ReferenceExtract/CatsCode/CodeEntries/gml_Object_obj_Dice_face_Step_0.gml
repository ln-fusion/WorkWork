if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (Skip == 1)
    {
        Skip = 0;
        exit;
    }
    if (!instance_exists(Master))
    {
        instance_destroy();
        exit;
    }
    if (Shop_cat == 1)
    {
        if (Master.Moused_over == 0)
        {
            instance_destroy();
            exit;
        }
    }
    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
    {
        if (Moused_over == 0)
        {
            Moused_over = 1;
        }
        if (obj_Cursor.Holding == 0 && !instance_exists(obj_UI_Dice_body))
        {
            if (array_length(Dice_effect) > 0)
            {
                var var_num = 0;
                var var_y = 0;
                draw_set_font(global.font_norm1);
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
    }
    else
    {
        Moused_over = 0;
    }
}
else if (global.Game_Pause == 1)
{
}
