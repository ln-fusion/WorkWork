function scr_Boonbane_setup(arg0, arg1, arg2)
{
    if (arg0 == "Boon")
    {
        switch (arg1)
        {
            case UnknownEnum.Value_0:
                if (arg2 == 0)
                {
                    with (global_Level)
                    {
                        ds_list_add(List_bonus, ["Blackjack", 0, 0, 1]);
                        scr_Bonus_initialize();
                    }
                }
                break;
            case UnknownEnum.Value_1:
                if (arg2 == 0)
                {
                    global.Player_score += 1;
                    global.Round_score += 1;
                }
                break;
            case UnknownEnum.Value_2:
                if (arg2 == 0)
                {
                    global.Player_reroll += 2;
                    global.Round_reroll += 2;
                }
                break;
            case UnknownEnum.Value_3:
                global.Extra_earnings += 2;
                break;
            case UnknownEnum.Value_4:
                if (arg2 == 0)
                {
                    if (!ds_list_empty(global_Level.List_bonus))
                    {
                        for (var var_i = 0; var_i < ds_list_size(global_Level.List_bonus); var_i += 1)
                        {
                            var var_bonus = ds_list_find_value(global_Level.List_bonus, var_i);
                            array_set(var_bonus, 1, var_bonus[1] + 5);
                            array_set(var_bonus, 2, var_bonus[2] + 1);
                        }
                        scr_Bonus_initialize();
                    }
                }
                break;
            case UnknownEnum.Value_5:
                if (arg2 == 0)
                {
                    global.Start_mult += 4;
                }
                break;
            case UnknownEnum.Value_6:
                if (arg2 == 0)
                {
                    global.Player_gold = global.Player_gold * 2;
                }
                break;
        }
    }
    else if (arg0 == "Bane")
    {
        switch (arg1)
        {
            case UnknownEnum.Value_1:
                global.Cat_lock = 1;
                break;
            case UnknownEnum.Value_2:
                global.Max_reroll = 5;
                break;
            case UnknownEnum.Value_3:
                global.Interest_rate = 0;
                global.Extra_earnings -= 1;
                break;
            case UnknownEnum.Value_4:
                if (arg2 == 0)
                {
                    global.Start_points -= 20;
                }
                break;
            case UnknownEnum.Value_5:
                global.Bonus_null += 1;
                break;
            case UnknownEnum.Value_6:
                global.Multminus_reroll4 += 2;
                break;
            case UnknownEnum.Value_9:
                global.Reroll_lock = 3;
                break;
        }
    }
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_9 = 9
}
