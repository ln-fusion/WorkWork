if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (global.Phase == "Play")
    {
        var var_roll = 0;
        var var_state = 0;
        with (obj_Dice)
        {
            if (Rolling != 0)
            {
                var_roll = 1;
            }
            if (Dice_tray < 0)
            {
                var_state = 1;
            }
        }
        if (var_state == 0)
        {
            currentspr = spr_Button_Release;
        }
        else
        {
            currentspr = spr_Button_Lock;
        }
        if (obj_Cursor.Holding == 0)
        {
            if (var_roll == 0)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (subimg == 0)
                    {
                        audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    }
                    subimg = 1;
                    if (global.Lmouse_pressed)
                    {
                        audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                        if (var_state == 0)
                        {
                            if (instance_exists(obj_Dice))
                            {
                                for (var var_i = 0; var_i < 6; var_i += 1)
                                {
                                    var var_position = -4;
                                    with (obj_Position)
                                    {
                                        if (Position == var_i)
                                        {
                                            var_position = id;
                                        }
                                    }
                                    var var_total = 0;
                                    with (obj_Dice)
                                    {
                                        if (Dice_tray > 0)
                                        {
                                            var_total += 1;
                                        }
                                    }
                                    for (var var_j = 1; var_j < (var_total + 1); var_j += 1)
                                    {
                                        var var_break = 0;
                                        with (obj_Dice)
                                        {
                                            if (Dice_tray == var_j)
                                            {
                                                var var_ok = 1;
                                                var_ok = scr_Cat_diceplace_check(var_position, id);
                                                if (var_ok == 1)
                                                {
                                                    audio_play_sound(sfx_Dice_slotin, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                                                    x = var_position.x;
                                                    y = var_position.y + 20;
                                                    xscale = 1.1;
                                                    yscale = 1.1;
                                                    with (var_position)
                                                    {
                                                        Dice_ID = other.id;
                                                    }
                                                    with (obj_Dice_tray)
                                                    {
                                                        Dice_total -= 1;
                                                    }
                                                    with (obj_Dice)
                                                    {
                                                        if (Dice_tray > other.Dice_tray)
                                                        {
                                                            Dice_tray -= 1;
                                                        }
                                                    }
                                                    Dice_tray = -1;
                                                    scr_Dice_combo_check(0);
                                                    var_break = 1;
                                                    break;
                                                }
                                            }
                                        }
                                        if (var_break == 1)
                                        {
                                            break;
                                        }
                                    }
                                }
                                with (obj_Dice)
                                {
                                    if (Dice_tray > 0)
                                    {
                                        Rolling = 1.2;
                                    }
                                }
                            }
                        }
                        else if (var_state == 1)
                        {
                            for (var var_i = 0; var_i < 6; var_i += 1)
                            {
                                var var_dice = -4;
                                with (obj_Position)
                                {
                                    if (Position == var_i)
                                    {
                                        if (Dice_ID != -4)
                                        {
                                            var_dice = Dice_ID;
                                            Dice_ID = -4;
                                        }
                                    }
                                }
                                if (var_dice != -4)
                                {
                                    with (var_dice)
                                    {
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
                                }
                            }
                        }
                    }
                }
                else
                {
                    subimg = 0;
                }
            }
            else
            {
                subimg = 2;
            }
        }
        else
        {
            subimg = 2;
        }
    }
    else
    {
        if (global.Phase == "Shop")
        {
            Text = "";
        }
        subimg = 2;
    }
}
else if (global.Game_Pause == 1)
{
}
