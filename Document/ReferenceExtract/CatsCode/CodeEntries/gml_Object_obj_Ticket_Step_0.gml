if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (Ticket_buy != 0)
    {
        if (Ticket_buy == 1)
        {
            global.Player_gold -= Ticket_cost;
            if (Ticket_cost > 0)
            {
                audio_play_sound(sfx_UI_money_spent, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            }
            else
            {
                audio_play_sound(sfx_UI_money_gain, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            }
            with (global_Level)
            {
                Ticket_refresh = Ticket_refresh_max;
            }
        }
        ds_list_delete(global_Level.Shoplist_ticket, 0);
        if (ds_list_empty(global_Level.Shoplist_ticket))
        {
            with (global_Level)
            {
                for (var var_i = 0; var_i < UnknownEnum.Value_3; var_i += 1)
                {
                    ds_list_add(Shoplist_ticket, var_i);
                }
                for (var var_j = 4; var_j < UnknownEnum.Value_6; var_j += 1)
                {
                    ds_list_add(Shoplist_ticket, var_j);
                }
                ds_list_shuffle(Shoplist_ticket);
                for (var var_k = 0; var_k < UnknownEnum.Value_3; var_k += 1)
                {
                    var var_pos = ds_list_find_index(Shoplist_ticket, var_k);
                    if (var_pos < floor(ds_list_size(Shoplist_ticket) / 2))
                    {
                        var var_random = irandom_range(floor(ds_list_size(Shoplist_ticket) / 2) + 1, ds_list_size(Shoplist_ticket) - 1);
                        ds_list_insert(Shoplist_ticket, var_random, var_k);
                    }
                    else
                    {
                        var var_random = irandom_range(0, floor(ds_list_size(Shoplist_ticket) / 2));
                        ds_list_insert(Shoplist_ticket, var_random, var_k);
                    }
                }
            }
        }
        Ticket_type = ds_list_find_value(global_Level.Shoplist_ticket, 0);
        scr_Ticket_setup(Ticket_type);
        Ticket_buy = 0;
        with (global_Level)
        {
            scr_Save_run();
            scr_Save_cat();
            scr_Save_shop();
        }
        exit;
    }
    if (obj_Cursor.Holding == 0)
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
                if (Ticket_cost <= 0)
                {
                    audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                    scr_Ticket_select(Ticket_type);
                }
                else if (global.Player_gold >= Ticket_cost)
                {
                    audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                    scr_Ticket_select(Ticket_type);
                }
                else
                {
                    audio_play_sound(sfx_UI_invalid, 90, false, global.Ctrl_SFX, 0, 1);
                }
            }
        }
        else
        {
            subimg = 0;
        }
    }
}
else if (global.Game_Pause == 1)
{
}

enum UnknownEnum
{
    Value_3 = 3,
    Value_6 = 6
}
