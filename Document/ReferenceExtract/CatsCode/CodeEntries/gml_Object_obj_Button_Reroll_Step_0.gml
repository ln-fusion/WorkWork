if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (global.Phase == "Play")
    {
        var var_check = 0;
        if (global.Max_reroll > 0)
        {
            if (global.Track_reroll >= global.Max_reroll)
            {
                var_check = 1;
            }
        }
        var var_num = 0;
        with (obj_Dice)
        {
            if (Dice_tray <= 0)
            {
                var_num += 1;
            }
        }
        if (global.Round_reroll > 0 && var_check == 0 && var_num <= global.Reroll_lock)
        {
            if (obj_Cursor.Holding == 0)
            {
                var var_roll = 0;
                with (obj_Dice)
                {
                    if (Rolling != 0)
                    {
                        var_roll = 1;
                    }
                }
                if (var_roll == 0)
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
                            audio_play_sound(sfx_UI_button_reroll, 80, false, global.Ctrl_SFX, 0, 1);
                            subimg = 2;
                            shift_y = 0;
                            global.Track_reroll += 1;
                            global.Round_reroll -= 1;
                            global.Phase = "Start_wait";
                            var var_reroll_num = 0;
                            with (obj_Dice)
                            {
                                if (Dice_tray > 0)
                                {
                                    var_reroll_num += 1;
                                    if (Face_next > 0)
                                    {
                                        Dice_face = Face_next;
                                        Face_next = 0;
                                    }
                                    else
                                    {
                                        Dice_face = choose(1, 2, 3, 4, 5, 6);
                                    }
                                    Rolling = 1.05;
                                    spin = irandom_range(26, 28);
                                    subimg = -1;
                                    face_change = -6;
                                    Draw_effect = 0;
                                }
                            }
                            if (global.Multminus_reroll4 > 0)
                            {
                                if (var_reroll_num >= 4)
                                {
                                    global.Mult -= global.Multminus_reroll4;
                                    global.Mult_next -= global.Multminus_reroll4;
                                }
                            }
                            if (global.Multminus_reroll > 0)
                            {
                                global.Mult -= global.Multminus_reroll;
                                global.Mult_next -= global.Multminus_reroll;
                            }
                            global.Chips_display = global.Chips;
                            global.Mult_display = global.Mult;
                            for (var var_i = 0; var_i < 6; var_i += 1)
                            {
                                var var_trigger = 0;
                                with (obj_Cat)
                                {
                                    if (Cat_pos == var_i)
                                    {
                                        for (var var_j = 0; var_j < Passive_max; var_j += 1)
                                        {
                                            switch (Passive[var_j])
                                            {
                                                case UnknownEnum.Value_26:
                                                    var var_dice = -4;
                                                    with (obj_Position)
                                                    {
                                                        if (Position == var_i)
                                                        {
                                                            var_dice = Dice_ID;
                                                        }
                                                    }
                                                    var var_increase = Cat_num[var_j];
                                                    if (var_dice != -4)
                                                    {
                                                        with (var_dice)
                                                        {
                                                            if (Dice_tray == -1)
                                                            {
                                                                Dice_value[Dice_face] += var_increase;
                                                                subimg = Dice_value[Dice_face];
                                                                scr_Dice_combo_check(0);
                                                                instance_create_layer(x, y, "UI", obj_vfx_diceup);
                                                                if (subimg > 6)
                                                                {
                                                                    value_scale = 0.6;
                                                                }
                                                                else
                                                                {
                                                                    value_scale = 0.25;
                                                                }
                                                            }
                                                        }
                                                        var_trigger = 1;
                                                        if (Anim_state == 0)
                                                        {
                                                            Anim_state = 1;
                                                        }
                                                        else
                                                        {
                                                            Anim_delay += 1;
                                                        }
                                                    }
                                                    break;
                                            }
                                        }
                                        if (var_trigger == 1)
                                        {
                                            scr_Cat_trigger(1);
                                        }
                                    }
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
            if (var_num > global.Reroll_lock)
            {
            }
        }
    }
    else if (global.Phase == "Shop")
    {
        if (obj_Cursor.Holding == 0)
        {
            if (global.Player_gold >= global_Level.Reroll_cost)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (subimg == 0)
                    {
                        audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                        subimg = 1;
                    }
                    else if (subimg == 2)
                    {
                        subimg = 2.1;
                    }
                    else if (subimg == 2.1)
                    {
                        subimg = 0.1;
                    }
                    else if (subimg == 0.1)
                    {
                        subimg = 1;
                    }
                    shift_y = -1;
                    if (global.Lmouse_pressed)
                    {
                        audio_play_sound(sfx_UI_button_reroll, 80, false, global.Ctrl_SFX, 0, 1);
                        audio_play_sound(sfx_UI_money_spent, 80, false, global.Ctrl_SFX, 0, 1);
                        subimg = 2;
                        shift_y = 0;
                        with (global_Level)
                        {
                            global.Player_gold -= Reroll_cost;
                            Reroll_cost *= 2;
                            if (Reroll_cost == 0)
                            {
                                Reroll_cost = 1;
                            }
                            with (obj_Cat)
                            {
                                if (Shop_created == 1)
                                {
                                    ds_list_add(global_Level.Shoplist_cat, Cat_type);
                                    Anim_state = -1;
                                }
                            }
                            with (obj_Item)
                            {
                                if (Shop_created == 1)
                                {
                                    ds_list_add(global_Level.Shoplist_item, Item_type);
                                    Anim_state = -1;
                                }
                            }
                            global.Phase = "Shop_start";
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
    else
    {
        subimg = 2;
        shift_y = 0;
    }
}
else if (global.Game_Pause == 1)
{
}

enum UnknownEnum
{
    Value_26 = 26
}
