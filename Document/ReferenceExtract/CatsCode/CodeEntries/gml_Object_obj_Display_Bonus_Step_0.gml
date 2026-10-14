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
    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
    {
        if (subimg == 0)
        {
            audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
        }
        subimg = 1;
        if (global.Lmouse_pressed)
        {
            audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            switch (Open_num)
            {
                case UnknownEnum.Value_7:
                    var var_bonus = ds_list_find_value(global_Level.List_bonus, Bonus_num);
                    array_set(var_bonus, 1, var_bonus[1] + 6);
                    array_set(var_bonus, 2, var_bonus[2] + 2);
                    scr_Bonus_initialize();
                    break;
                case UnknownEnum.Value_0:
                    var var_bonus = ds_list_find_value(global_Level.List_bonus, Bonus_num);
                    array_set(var_bonus, 1, var_bonus[1] + 8);
                    array_set(var_bonus, 2, var_bonus[2] + 2);
                    for (var var_i = 0; var_i < ds_list_size(global_Level.List_bonus); var_i += 1)
                    {
                        if (var_i != Bonus_num)
                        {
                            var_bonus = ds_list_find_value(global_Level.List_bonus, var_i);
                            array_set(var_bonus, 1, var_bonus[1] - 2);
                            array_set(var_bonus, 2, var_bonus[2] - 1);
                        }
                    }
                    scr_Bonus_initialize();
                    break;
                case UnknownEnum.Value_1:
                    var var_bonus = ds_list_find_value(global_Level.List_bonus, Bonus_num);
                    var var_points_add = ceil(0.15 * var_bonus[1]);
                    if (var_points_add > 20)
                    {
                        var_points_add = 20;
                    }
                    var var_mult_add = ceil(0.15 * var_bonus[2]);
                    if (var_mult_add > 5)
                    {
                        var_mult_add = 5;
                    }
                    array_set(var_bonus, 1, var_bonus[1] + var_points_add);
                    array_set(var_bonus, 2, var_bonus[2] + var_mult_add);
                    scr_Bonus_initialize();
                    break;
                case UnknownEnum.Value_2:
                    ds_list_delete(global_Level.List_bonus, Bonus_num);
                    scr_Bonus_initialize();
                    break;
            }
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            global.Game_Pause = 0;
            with (obj_Button_Bonus)
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
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_7 = 7
}
