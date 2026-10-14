if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (global.Phase == "Play")
    {
        var var_placed = 0;
        with (obj_Dice)
        {
            if (Dice_tray == -1)
            {
                var_placed += 1;
            }
        }
        if (var_placed > 0)
        {
            if (obj_Cursor.Holding == 0)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (subimg == 0)
                    {
                        audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    }
                    subimg = 1;
                    shift_y = -1;
                    if (global.Lmouse_pressed)
                    {
                        audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                        subimg = 2;
                        shift_y = 0;
                        global.Round_score -= 1;
                        global.Attempt_score += 1;
                        if (global.Moneyminus_onscore > 0)
                        {
                            if (global.Attempt_score >= 2)
                            {
                                global.Player_gold -= global.Moneyminus_onscore;
                            }
                        }
                        global.Phase = "Score";
                        scr_Cat_score_check();
                        with (obj_Ctrl_Cat)
                        {
                            Score_start = 1;
                        }
                        with (obj_Position)
                        {
                            if (Position == 0)
                            {
                                counter = counter_max;
                            }
                        }
                    }
                }
                else
                {
                    subimg = 0;
                    shift_y = 0;
                }
            }
            else
            {
                subimg = 2;
                shift_y = 0;
            }
        }
        else
        {
            subimg = 2;
            shift_y = 0;
        }
    }
    else if (global.Phase == "Shop")
    {
        if (obj_Cursor.Holding == 0)
        {
            if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
            {
                if (subimg == 0)
                {
                    audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                }
                subimg = 1;
                shift_y = -1;
                if (global.Lmouse_pressed)
                {
                    audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                    subimg = 2;
                    shift_y = 0;
                    Text = Text_score;
                    with (obj_Cat)
                    {
                        if (Shop_created == 1)
                        {
                            instance_destroy();
                        }
                    }
                    with (obj_Item)
                    {
                        if (Shop_created == 1)
                        {
                            instance_destroy();
                        }
                    }
                    with (obj_Ticket)
                    {
                        instance_destroy();
                    }
                    with (global_Level)
                    {
                        Reroll_cost = global.Shop_rerollcost;
                    }
                    with (obj_Ctrl_Cat)
                    {
                        centerboard_subimg = 0;
                    }
                    global.Chips_display = 0;
                    global.Mult_display = 0;
                    global.Phase = "Start_setup";
                    global.Round_score = global.Player_score;
                    global.Round_reroll = global.Player_reroll;
                }
            }
            else
            {
                subimg = 0;
                shift_y = 0;
            }
        }
        else
        {
            subimg = 2;
            shift_y = 0;
        }
    }
    else
    {
        subimg = 2;
        shift_y = 0;
    }
}
else if (global.Game_Pause == 1)
{
}
