function scr_Cat_diceplace_check(arg0, arg1)
{
    var var_ok = 1;
    var var_cat = -4;
    with (arg0)
    {
        if (place_meeting(x, y, obj_Cat))
        {
            var_cat = instance_place(x, y, obj_Cat);
        }
    }
    if (var_cat != -4)
    {
        with (var_cat)
        {
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
        }
    }
    return var_ok;
}

enum UnknownEnum
{
    Value_28 = 28,
    Value_40 = 40
}
