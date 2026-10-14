function scr_Ticket_select(arg0)
{
    switch (arg0)
    {
        case UnknownEnum.Value_7:
            with (obj_Button_Bonus)
            {
                Open_list = 1;
                Open_by = "Ticket";
                Open_num = arg0;
            }
            break;
        case UnknownEnum.Value_0:
            with (obj_Button_Bonus)
            {
                Open_list = 1;
                Open_by = "Ticket";
                Open_num = arg0;
            }
            break;
        case UnknownEnum.Value_1:
            with (obj_Button_Bonus)
            {
                Open_list = 1;
                Open_by = "Ticket";
                Open_num = arg0;
            }
            break;
        case UnknownEnum.Value_2:
            with (obj_Button_Bonus)
            {
                Open_list = 1;
                Open_by = "Ticket";
                Open_num = arg0;
            }
            break;
        case UnknownEnum.Value_4:
            global.Start_points -= 10;
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_5:
            global.Start_mult -= 2;
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_100:
            global.Shop_rerollcost = 0;
            if (global_Level.Reroll_cost == 1)
            {
                with (global_Level)
                {
                    Reroll_cost = 0;
                }
            }
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_101:
            with (global_Level)
            {
                ds_list_add(List_bonus, ["Lowroll", 50, 8, 1]);
            }
            scr_Bonus_initialize();
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_102:
            with (global_Level)
            {
                ds_list_add(List_bonus, ["Highroll", 50, 8, 1]);
            }
            scr_Bonus_initialize();
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_103:
            with (global_Level)
            {
                ds_list_add(List_bonus, ["Straight", 40, 9, 1]);
            }
            scr_Bonus_initialize();
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_104:
            with (global_Level)
            {
                ds_list_add(List_bonus, ["Empty", 100, 10, 1]);
            }
            scr_Bonus_initialize();
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_106:
            global.Player_score += 1;
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_107:
            global.Player_reroll += 1;
            with (obj_Ticket)
            {
                Ticket_buy = 1;
            }
            break;
        case UnknownEnum.Value_108:
            if (!ds_list_empty(global_Level.List_bane))
            {
                with (obj_Button_Boonbane)
                {
                    Open_list = 1;
                    Open_by = "Ticket";
                    Open_num = arg0;
                }
            }
            else
            {
                with (obj_Ticket)
                {
                    Ticket_buy = 1;
                }
            }
            break;
    }
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_4 = 4,
    Value_5,
    Value_7 = 7,
    Value_100 = 100,
    Value_101,
    Value_102,
    Value_103,
    Value_104,
    Value_106 = 106,
    Value_107,
    Value_108
}
