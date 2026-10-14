function scr_Dice_combo_check(arg0)
{
    scr_Dice_combo_reset();
    if (arg0 == 0)
    {
        var var_bonus_num = 0;
        global.Chips = global.Chips_next + global.Start_points;
        global.Mult = global.Mult_next + global.Start_mult;
        var var_check = 0;
        with (obj_Dice)
        {
            if (Dice_tray == -1)
            {
                var_check = 1;
            }
        }
        if (var_check == 0)
        {
            exit;
        }
        var var_list = ds_list_create();
        var var_combo = ds_list_create();
        with (obj_Dice)
        {
            if (Dice_tray == -1)
            {
                ds_list_add(var_list, Dice_value[Dice_face]);
            }
        }
        if (global.Bonus_dif6 != 0)
        {
            if (ds_list_size(var_list) == 6)
            {
                ds_list_sort(var_list, true);
                var var_value = -1;
                var var_total = 0;
                for (var var_g = 0; var_g < 6; var_g += 1)
                {
                    if (ds_list_find_value(var_list, var_g) > var_value)
                    {
                        var_total += 1;
                        var_value = ds_list_find_value(var_list, var_g);
                    }
                }
                if (var_total == 6)
                {
                    if (global.Bonus_dif6 == 1)
                    {
                        global.Chips += global.Bonus_dif6_chips;
                        global.Mult += global.Bonus_dif6_mult;
                        global.Track_dif6 += 1;
                        var_bonus_num += 1;
                    }
                    else if (global.Bonus_dif6 == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_display = 1;
                        }
                    }
                }
            }
        }
        if (global.Bonus_21 != 0)
        {
            var var_total = 0;
            for (var var_g = 0; var_g < ds_list_size(var_list); var_g += 1)
            {
                var_total += ds_list_find_value(var_list, var_g);
            }
            if (global.Bonus_21 == 1)
            {
                if (var_total == 21)
                {
                    global.Chips += global.Bonus_21_chips;
                    global.Mult += global.Bonus_21_mult;
                    global.Track_21 = 1;
                    var_bonus_num += 1;
                }
                else if (var_total > 21)
                {
                    global.Track_21 = -1;
                }
            }
            else if (global.Bonus_21 == -1)
            {
                if (var_total == 21)
                {
                    with (obj_Ctrl_Cat)
                    {
                        infobar_display = 1;
                    }
                }
            }
        }
        if (global.Bonus_lowroll != 0)
        {
            var var_templist = ds_list_create();
            ds_list_copy(var_templist, var_list);
            ds_list_sort(var_templist, false);
            var var_value = ds_list_find_value(var_templist, 0);
            if (var_value <= 3)
            {
                if (global.Bonus_lowroll == 1)
                {
                    global.Chips += global.Bonus_lowroll_chips;
                    global.Mult += global.Bonus_lowroll_mult;
                    global.Track_lowroll = 1;
                    var_bonus_num += 1;
                }
                else if (global.Bonus_lowroll == -1)
                {
                    with (obj_Ctrl_Cat)
                    {
                        infobar_display = 1;
                    }
                }
            }
            ds_list_destroy(var_templist);
        }
        if (global.Bonus_highroll != 0)
        {
            var var_templist = ds_list_create();
            ds_list_copy(var_templist, var_list);
            ds_list_sort(var_templist, true);
            var var_value = ds_list_find_value(var_templist, 0);
            if (var_value >= 4)
            {
                if (global.Bonus_highroll == 1)
                {
                    global.Chips += global.Bonus_highroll_chips;
                    global.Mult += global.Bonus_highroll_mult;
                    global.Track_highroll = 1;
                    var_bonus_num += 1;
                }
                else if (global.Bonus_highroll == -1)
                {
                    with (obj_Ctrl_Cat)
                    {
                        infobar_display = 1;
                    }
                }
            }
            ds_list_destroy(var_templist);
        }
        if (global.Bonus_straight != 0)
        {
            var var_templist = ds_list_create();
            ds_list_copy(var_templist, var_list);
            ds_list_sort(var_templist, true);
            var var_num = 0;
            var var_max = 0;
            for (var var_i = 0; var_i < ds_list_size(var_templist); var_i += 1)
            {
                if (var_i > 0)
                {
                    if (ds_list_find_value(var_templist, var_i) == ds_list_find_value(var_templist, var_i - 1))
                    {
                    }
                    else if (ds_list_find_value(var_templist, var_i) == (ds_list_find_value(var_templist, var_i - 1) + 1))
                    {
                        var_num += 1;
                        if (var_num > var_max)
                        {
                            var_max = var_num;
                        }
                    }
                    else
                    {
                        var_num = 0;
                    }
                }
            }
            if (var_max >= 3)
            {
                if (global.Bonus_straight == 1)
                {
                    global.Chips += global.Bonus_straight_chips;
                    global.Mult += global.Bonus_straight_mult;
                    global.Track_straight = 1;
                    var_bonus_num += 1;
                }
                else if (global.Bonus_straight == -1)
                {
                    with (obj_Ctrl_Cat)
                    {
                        infobar_display = 1;
                    }
                }
            }
            ds_list_destroy(var_templist);
        }
        while (ds_list_size(var_list) >= 2)
        {
            var var_find = 1;
            var var_value = ds_list_find_value(var_list, 0);
            var var_i = ds_list_size(var_list) - 1;
            while (var_i > -1)
            {
                if (var_i == 0)
                {
                    ds_list_delete(var_list, 0);
                }
                else if (ds_list_find_value(var_list, var_i) == var_value)
                {
                    var_find += 1;
                    ds_list_delete(var_list, var_i);
                }
                var_i += -1;
            }
            if (var_find > 1)
            {
                ds_list_add(var_combo, var_find);
            }
        }
        if (ds_list_size(var_combo) > 0)
        {
            for (var var_j = 0; var_j < ds_list_size(var_combo); var_j += 1)
            {
                var var_type = ds_list_find_value(var_combo, var_j);
                switch (var_type)
                {
                    case 2:
                        if (global.Bonus_pair == 1)
                        {
                            global.Chips += global.Bonus_pair_chips;
                            global.Mult += global.Bonus_pair_mult;
                            global.Track_pair += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == -1)
                        {
                            with (obj_Ctrl_Cat)
                            {
                                infobar_display = 1;
                            }
                        }
                        break;
                    case 3:
                        if (global.Bonus_same3 == 1)
                        {
                            global.Chips += global.Bonus_same3_chips;
                            global.Mult += global.Bonus_same3_mult;
                            global.Track_same3 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Chips += global.Bonus_pair_chips;
                            global.Mult += global.Bonus_pair_mult;
                            global.Track_pair += 1;
                            var_bonus_num += 1;
                        }
                        if (global.Bonus_same3 == -1)
                        {
                            with (obj_Ctrl_Cat)
                            {
                                infobar_display = 1;
                            }
                        }
                        break;
                    case 4:
                        if (global.Bonus_same4 == 1)
                        {
                            global.Chips += global.Bonus_same4_chips;
                            global.Mult += global.Bonus_same4_mult;
                            global.Track_same4 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same3 == 1)
                        {
                            global.Chips += global.Bonus_same3_chips;
                            global.Mult += global.Bonus_same3_mult;
                            global.Track_same3 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Chips += (global.Bonus_pair_chips * 2);
                            global.Mult += (global.Bonus_pair_mult * 2);
                            global.Track_pair += 2;
                            var_bonus_num += 2;
                        }
                        if (global.Bonus_same4 == -1)
                        {
                            with (obj_Ctrl_Cat)
                            {
                                infobar_display = 1;
                            }
                        }
                        break;
                    case 5:
                        if (global.Bonus_same5 == 1)
                        {
                            global.Chips += global.Bonus_same5_chips;
                            global.Mult += global.Bonus_same5_mult;
                            global.Track_same5 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same4 == 1)
                        {
                            global.Chips += global.Bonus_same4_chips;
                            global.Mult += global.Bonus_same4_mult;
                            global.Track_same4 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same3 == 1)
                        {
                            global.Chips += global.Bonus_same3_chips;
                            global.Mult += global.Bonus_same3_mult;
                            global.Track_same3 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Chips += (global.Bonus_pair_chips * 2);
                            global.Mult += (global.Bonus_pair_mult * 2);
                            global.Track_pair += 2;
                            var_bonus_num += 2;
                        }
                        if (global.Bonus_same5 == -1)
                        {
                            with (obj_Ctrl_Cat)
                            {
                                infobar_display = 1;
                            }
                        }
                        break;
                    case 6:
                        if (global.Bonus_same6 == 1)
                        {
                            global.Chips += global.Bonus_same6_chips;
                            global.Mult += global.Bonus_same6_mult;
                            global.Track_same6 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same5 == 1)
                        {
                            global.Chips += global.Bonus_same5_chips;
                            global.Mult += global.Bonus_same5_mult;
                            global.Track_same5 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same4 == 1)
                        {
                            global.Chips += global.Bonus_same4_chips;
                            global.Mult += global.Bonus_same4_mult;
                            global.Track_same4 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same3 == 1)
                        {
                            global.Chips += (global.Bonus_same3_chips * 2);
                            global.Mult += (global.Bonus_same3_mult * 2);
                            global.Track_same3 += 2;
                            var_bonus_num += 2;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Chips += (global.Bonus_pair_chips * 3);
                            global.Mult += (global.Bonus_pair_mult * 3);
                            global.Track_pair += 3;
                            var_bonus_num += 3;
                        }
                        if (global.Bonus_same6 == -1)
                        {
                            with (obj_Ctrl_Cat)
                            {
                                infobar_display = 1;
                            }
                        }
                        break;
                }
            }
        }
        ds_list_destroy(var_list);
        ds_list_destroy(var_combo);
        if (global.Bonus_empty != 0)
        {
            if (var_bonus_num == 0)
            {
                if (global.Bonus_empty == 1)
                {
                    global.Chips += global.Bonus_empty_chips;
                    global.Mult += global.Bonus_empty_mult;
                    global.Track_empty = 1;
                }
                else if (global.Bonus_empty == -1)
                {
                    with (obj_Ctrl_Cat)
                    {
                        infobar_display = 1;
                    }
                }
            }
        }
    }
    else if (arg0 == 1)
    {
        var var_bonus_num = 0;
        var var_list = ds_list_create();
        var var_combo = ds_list_create();
        with (obj_Dice)
        {
            if (Dice_tray == -1)
            {
                ds_list_add(var_list, Dice_value[Dice_face]);
            }
        }
        if (global.Bonus_dif6 == 1)
        {
            if (ds_list_size(var_list) == 6)
            {
                ds_list_sort(var_list, true);
                var var_value = -1;
                var var_total = 0;
                for (var var_g = 0; var_g < 6; var_g += 1)
                {
                    if (ds_list_find_value(var_list, var_g) > var_value)
                    {
                        var_total += 1;
                        var_value = ds_list_find_value(var_list, var_g);
                    }
                }
                if (var_total == 6)
                {
                    global.Track_dif6 += 1;
                    var_bonus_num += 1;
                }
            }
        }
        if (global.Bonus_21 == 1)
        {
            var var_total = 0;
            for (var var_g = 0; var_g < ds_list_size(var_list); var_g += 1)
            {
                var_total += ds_list_find_value(var_list, var_g);
            }
            if (var_total == 21)
            {
                global.Track_21 = 1;
                var_bonus_num += 1;
            }
            else if (var_total > 21)
            {
                global.Track_21 = -1;
            }
        }
        if (global.Bonus_lowroll == 1)
        {
            var var_templist = ds_list_create();
            ds_list_copy(var_templist, var_list);
            ds_list_sort(var_templist, false);
            var var_value = ds_list_find_value(var_templist, 0);
            if (var_value <= 3)
            {
                global.Track_lowroll = 1;
                var_bonus_num += 1;
            }
            ds_list_destroy(var_templist);
        }
        if (global.Bonus_highroll == 1)
        {
            var var_templist = ds_list_create();
            ds_list_copy(var_templist, var_list);
            ds_list_sort(var_templist, true);
            var var_value = ds_list_find_value(var_templist, 0);
            if (var_value >= 4)
            {
                global.Track_highroll = 1;
                var_bonus_num += 1;
            }
            ds_list_destroy(var_templist);
        }
        if (global.Bonus_straight == 1)
        {
            var var_templist = ds_list_create();
            ds_list_copy(var_templist, var_list);
            ds_list_sort(var_templist, true);
            var var_num = 0;
            var var_max = 0;
            for (var var_i = 0; var_i < ds_list_size(var_templist); var_i += 1)
            {
                if (var_i > 0)
                {
                    if (ds_list_find_value(var_templist, var_i) == ds_list_find_value(var_templist, var_i - 1))
                    {
                    }
                    else if (ds_list_find_value(var_templist, var_i) == (ds_list_find_value(var_templist, var_i - 1) + 1))
                    {
                        var_num += 1;
                        if (var_num > var_max)
                        {
                            var_max = var_num;
                        }
                    }
                    else
                    {
                        var_num = 0;
                    }
                }
            }
            if (var_max >= 3)
            {
                global.Track_straight = 1;
                var_bonus_num += 1;
            }
            ds_list_destroy(var_templist);
        }
        while (ds_list_size(var_list) >= 2)
        {
            var var_find = 1;
            var var_value = ds_list_find_value(var_list, 0);
            var var_i = ds_list_size(var_list) - 1;
            while (var_i > -1)
            {
                if (var_i == 0)
                {
                    ds_list_delete(var_list, 0);
                }
                else if (ds_list_find_value(var_list, var_i) == var_value)
                {
                    var_find += 1;
                    ds_list_delete(var_list, var_i);
                }
                var_i += -1;
            }
            if (var_find > 1)
            {
                ds_list_add(var_combo, var_find);
            }
        }
        if (ds_list_size(var_combo) > 0)
        {
            for (var var_j = 0; var_j < ds_list_size(var_combo); var_j += 1)
            {
                var var_type = ds_list_find_value(var_combo, var_j);
                switch (var_type)
                {
                    case 2:
                        if (global.Bonus_pair == 1)
                        {
                            global.Track_pair += 1;
                            var_bonus_num += 1;
                        }
                        break;
                    case 3:
                        if (global.Bonus_same3 == 1)
                        {
                            global.Track_same3 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Track_pair += 1;
                            var_bonus_num += 1;
                        }
                        break;
                    case 4:
                        if (global.Bonus_same4 == 1)
                        {
                            global.Track_same4 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same3 == 1)
                        {
                            global.Track_same3 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Track_pair += 2;
                            var_bonus_num += 2;
                        }
                        break;
                    case 5:
                        if (global.Bonus_same5 == 1)
                        {
                            global.Track_same5 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same4 == 1)
                        {
                            global.Track_same4 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same3 == 1)
                        {
                            global.Track_same3 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Track_pair += 2;
                            var_bonus_num += 2;
                        }
                        break;
                    case 6:
                        if (global.Bonus_same6 == 1)
                        {
                            global.Track_same6 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same5 == 1)
                        {
                            global.Track_same5 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same4 == 1)
                        {
                            global.Track_same4 += 1;
                            var_bonus_num += 1;
                        }
                        else if (global.Bonus_same3 == 1)
                        {
                            global.Track_same3 += 2;
                            var_bonus_num += 2;
                        }
                        else if (global.Bonus_pair == 1)
                        {
                            global.Track_pair += 3;
                            var_bonus_num += 3;
                        }
                        break;
                }
            }
        }
        ds_list_destroy(var_list);
        ds_list_destroy(var_combo);
        if (global.Bonus_empty == 1)
        {
            if (var_bonus_num == 0)
            {
                global.Track_empty = 1;
            }
        }
    }
}
