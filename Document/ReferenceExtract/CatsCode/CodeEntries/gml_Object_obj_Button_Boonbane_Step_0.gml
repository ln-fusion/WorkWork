if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (!ds_list_empty(global_Level.List_boon))
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
    }
    else
    {
        subimg = 2;
    }
    if (Open_list == 1)
    {
        global.Game_Pause = 1;
        Selected = 1;
        with (obj_Button_Option)
        {
            depth = layer_get_depth("UI") - 2;
        }
        with (instance_create_layer(x, y, "UI", obj_Display_draw))
        {
            Master = other.id;
            Display_type = 1;
        }
        var var_num = 0;
        for (var var_i = 0; var_i < ds_list_size(global_Level.List_boon); var_i += 1)
        {
            var var_boon = ds_list_find_value(global_Level.List_boon, var_i);
            if (scr_Boonbane_tied(var_boon) == 0)
            {
                with (instance_create_layer(74, 32 + (var_num * 28), "UI", obj_Display_Boonbane))
                {
                    BoonBane_type = "Boon";
                    List_num = var_i;
                    Master = other.id;
                    Text = scr_Boonbane_text("Boon", var_boon);
                    currentspr = spr_Boon_display;
                }
                var_num += 1;
            }
        }
        var_num = 0;
        for (var var_j = 0; var_j < ds_list_size(global_Level.List_bane); var_j += 1)
        {
            var var_bane = ds_list_find_value(global_Level.List_bane, var_j);
            if (scr_Boonbane_tied(var_bane) == 0)
            {
                with (instance_create_layer(316, 32 + (var_num * 28), "UI", obj_Display_Boonbane))
                {
                    BoonBane_type = "Bane";
                    List_num = var_j;
                    Master = other.id;
                    Text = scr_Boonbane_text("Bane", var_bane);
                    currentspr = spr_Bane_display;
                    image_index = spr_Bane_display;
                    mask_index = spr_Bane_display;
                }
                var_num += 1;
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
