if (global.Game_Pause != 1)
{
    instance_destroy();
    exit;
}
if (instance_exists(Master))
{
    if (Master.Selected != 1)
    {
        instance_destroy();
        exit;
    }
}
if (Open_by == "Ticket")
{
    switch (Open_num)
    {
        case UnknownEnum.Value_108:
            if (BoonBane_type == "Boon")
            {
                subimg = 2;
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (global.Lmouse_pressed)
                    {
                        audio_play_sound(sfx_UI_invalid, 80, false, global.Ctrl_SFX, 0, 1);
                    }
                }
            }
            else if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
            {
                if (subimg == 0)
                {
                    audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
                }
                subimg = 1;
                if (global.Lmouse_pressed)
                {
                    audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    var var_bane = ds_list_find_value(global_Level.List_bane, List_num);
                    ds_list_delete(global_Level.List_bane, List_num);
                    switch (var_bane)
                    {
                        case UnknownEnum.Value_1:
                            global.Cat_lock = 0;
                            break;
                        case UnknownEnum.Value_2:
                            global.Max_reroll = 0;
                            break;
                        case UnknownEnum.Value_3:
                            global.Interest_rate = 1;
                            global.Extra_earnings += 1;
                            break;
                        case UnknownEnum.Value_4:
                            global.Start_points += 20;
                            break;
                        case UnknownEnum.Value_5:
                            global.Bonus_null -= 1;
                            break;
                        case UnknownEnum.Value_6:
                            global.Multminus_reroll4 -= 2;
                            break;
                        case UnknownEnum.Value_9:
                            global.Reroll_lock = 6;
                            break;
                    }
                    with (obj_Ticket)
                    {
                        Ticket_buy = 1;
                    }
                    global.Game_Pause = 0;
                    with (obj_Button_Boonbane)
                    {
                        Selected = 0;
                        Open_by = -4;
                        Open_num = -4;
                    }
                    with (obj_Button_Option)
                    {
                        depth = layer_get_depth("Base");
                    }
                }
            }
            else
            {
                subimg = 0;
            }
            break;
    }
}

enum UnknownEnum
{
    Value_1 = 1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_9 = 9,
    Value_108 = 108
}
