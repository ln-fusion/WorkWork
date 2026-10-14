function scr_Cat_positionplace_check(arg0, arg1)
{
    for (var var_m = 0; var_m < 6; var_m += 1)
    {
        with (obj_Cat)
        {
            if (Shop_created == 0)
            {
                if (Cat_pos == var_m)
                {
                    for (var var_o = 0; var_o < Passive_max; var_o += 1)
                    {
                        if (Passive[var_o] != -4)
                        {
                            scr_Cat_stats_reset(Passive[var_o], var_o);
                        }
                    }
                    var var_n = Passive_max - 1;
                    while (var_n >= 0)
                    {
                        switch (Passive[var_n])
                        {
                            case UnknownEnum.Value_3004:
                                for (var var_q = 0; var_q < var_n; var_q += 1)
                                {
                                    if (Cat_num[var_q] >= 0)
                                    {
                                        Cat_num[var_q] += Cat_num[var_n];
                                    }
                                    if (Cat_chips[var_q] >= 0)
                                    {
                                        Cat_chips[var_q] += Cat_num[var_n];
                                    }
                                    if (Cat_mult[var_q] >= 0)
                                    {
                                        Cat_mult[var_q] += Cat_num[var_n];
                                    }
                                }
                                break;
                        }
                        var_n -= 1;
                    }
                }
            }
        }
    }
    for (var var_j = 0; var_j < 6; var_j += 1)
    {
        with (obj_Cat)
        {
            if (Shop_created == 0)
            {
                if (Cat_pos == var_j && Selected == 0)
                {
                    for (var var_k = 0; var_k < Passive_max; var_k += 1)
                    {
                        switch (Passive[var_k])
                        {
                            case UnknownEnum.Value_46:
                                var var_plus = Cat_num[var_k];
                                var var_pos = Cat_pos;
                                with (obj_Cat)
                                {
                                    if (Shop_created == 0)
                                    {
                                        if (Cat_pos == (var_pos - 1) || Cat_pos == (var_pos + 1))
                                        {
                                            for (var var_i = 0; var_i < Passive_max; var_i += 1)
                                            {
                                                Cat_sunstone[var_i] = 0;
                                            }
                                            var var_l = Passive_max - 1;
                                            while (var_l >= 0)
                                            {
                                                if (Cat_num[var_l] >= 0)
                                                {
                                                    Cat_num[var_l] += var_plus;
                                                }
                                                if (Cat_chips[var_l] >= 0)
                                                {
                                                    Cat_chips[var_l] += var_plus;
                                                }
                                                if (Cat_mult[var_l] >= 0)
                                                {
                                                    Cat_mult[var_l] += var_plus;
                                                }
                                                switch (Passive[var_l])
                                                {
                                                    case UnknownEnum.Value_3004:
                                                        var var_n = Passive_max - 1;
                                                        while (var_n > var_l)
                                                        {
                                                            Cat_sunstone[var_l] += Cat_sunstone[var_n];
                                                            var_n -= 1;
                                                        }
                                                        for (var var_m = 0; var_m < var_l; var_m += 1)
                                                        {
                                                            if (Cat_num[var_m] >= 0)
                                                            {
                                                                Cat_num[var_m] += var_plus + Cat_sunstone[var_l];
                                                            }
                                                            if (Cat_chips[var_m] >= 0)
                                                            {
                                                                Cat_chips[var_m] += var_plus + Cat_sunstone[var_l];
                                                            }
                                                            if (Cat_mult[var_m] >= 0)
                                                            {
                                                                Cat_mult[var_m] += var_plus + Cat_sunstone[var_l];
                                                            }
                                                        }
                                                        Cat_sunstone[var_l] += var_plus;
                                                        break;
                                                }
                                                var_l -= 1;
                                            }
                                        }
                                    }
                                }
                                break;
                        }
                    }
                }
            }
        }
    }
    if (arg1 != -4)
    {
        var var_ok = 1;
        for (var var_i = 0; var_i < Passive_max; var_i += 1)
        {
            if (Passive[var_i] != -4)
            {
                switch (Passive[var_i])
                {
                    case UnknownEnum.Value_28:
                        if (arg1.Dice_value[arg1.Dice_face] < Cat_num[var_i])
                        {
                            var_ok = 0;
                        }
                        break;
                    case UnknownEnum.Value_40:
                        if (arg1.Dice_value[arg1.Dice_face] > Cat_num[var_i])
                        {
                            var_ok = 0;
                        }
                        break;
                }
            }
        }
        if (var_ok == 0)
        {
            with (arg1)
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
            }
            with (arg0)
            {
                Dice_ID = -4;
            }
        }
    }
}

enum UnknownEnum
{
    Value_28 = 28,
    Value_40 = 40,
    Value_46 = 46,
    Value_3004 = 3004
}
