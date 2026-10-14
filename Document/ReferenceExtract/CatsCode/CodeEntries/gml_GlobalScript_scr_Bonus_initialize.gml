function scr_Bonus_initialize()
{
    global.Bonus_pair = 0;
    global.Bonus_same3 = 0;
    global.Bonus_same4 = 0;
    global.Bonus_same5 = 0;
    global.Bonus_same6 = 0;
    global.Bonus_dif6 = 0;
    global.Bonus_21 = 0;
    global.Bonus_lowroll = 0;
    global.Bonus_highroll = 0;
    global.Bonus_straight = 0;
    global.Bonus_empty = 0;
    if (ds_list_size(global_Level.List_bonus) > 0)
    {
        for (var var_i = 0; var_i < ds_list_size(global_Level.List_bonus); var_i += 1)
        {
            var var_bonus = ds_list_find_value(global_Level.List_bonus, var_i);
            switch (var_bonus[0])
            {
                case "Pair":
                    global.Bonus_pair = var_bonus[3];
                    global.Bonus_pair_chips = var_bonus[1];
                    global.Bonus_pair_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusPair;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Triple":
                    global.Bonus_same3 = var_bonus[3];
                    global.Bonus_same3_chips = var_bonus[1];
                    global.Bonus_same3_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusTriple;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "4Kind":
                    global.Bonus_same4 = var_bonus[3];
                    global.Bonus_same4_chips = var_bonus[1];
                    global.Bonus_same4_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusSame4;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "5Kind":
                    global.Bonus_same5 = var_bonus[3];
                    global.Bonus_same5_chips = var_bonus[1];
                    global.Bonus_same5_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusSame5;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "6Kind":
                    global.Bonus_same6 = var_bonus[3];
                    global.Bonus_same6_chips = var_bonus[1];
                    global.Bonus_same6_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusSame6;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Distinct":
                    global.Bonus_dif6 = var_bonus[3];
                    global.Bonus_dif6_chips = var_bonus[1];
                    global.Bonus_dif6_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusAlldif;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Blackjack":
                    global.Bonus_21 = var_bonus[3];
                    global.Bonus_21_chips = var_bonus[1];
                    global.Bonus_21_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusBlackjack;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Lowroll":
                    global.Bonus_lowroll = var_bonus[3];
                    global.Bonus_lowroll_chips = var_bonus[1];
                    global.Bonus_lowroll_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusLowroll;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Highroll":
                    global.Bonus_highroll = var_bonus[3];
                    global.Bonus_highroll_chips = var_bonus[1];
                    global.Bonus_highroll_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusHighroll;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Straight":
                    global.Bonus_straight = var_bonus[3];
                    global.Bonus_straight_chips = var_bonus[1];
                    global.Bonus_straight_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusStraight;
                            infobar_display = 1;
                        }
                    }
                    break;
                case "Empty":
                    global.Bonus_empty = var_bonus[3];
                    global.Bonus_empty_chips = var_bonus[1];
                    global.Bonus_empty_mult = var_bonus[2];
                    if (var_bonus[3] == -1)
                    {
                        with (obj_Ctrl_Cat)
                        {
                            infobar_text = Text_BonusEmpty;
                            infobar_display = 1;
                        }
                    }
                    break;
            }
        }
    }
}
