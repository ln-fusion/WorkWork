function scr_Ticket_setup(arg0)
{
    switch (arg0)
    {
        case UnknownEnum.Value_7:
            Ticket_cost = 10;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Bonus_valueup_title", "");
            Text_body = ini_read_string("Ticket_text", "Bonus_valueup_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_0:
            Ticket_cost = 10;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Bonus_valuetransfer_title", "");
            Text_body = ini_read_string("Ticket_text", "Bonus_valuetransfer_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_1:
            Ticket_cost = 10;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Bonus_percentageup_title", "");
            Text_body = ini_read_string("Ticket_text", "Bonus_percentageup_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_2:
            Ticket_cost = -4;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Remove_bonus_title", "");
            Text_body = ini_read_string("Ticket_text", "Remove_bonus_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_4:
            Ticket_cost = -7;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Bonus_reducepoints_title", "");
            Text_body = ini_read_string("Ticket_text", "Bonus_reducepoints_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_5:
            Ticket_cost = -7;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Bonus_reducemult_title", "");
            Text_body = ini_read_string("Ticket_text", "Bonus_reducemult_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_100:
            Ticket_cost = 10;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Discount_reroll_title", "");
            Text_body = ini_read_string("Ticket_text", "Discount_reroll_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_101:
            Ticket_cost = 9;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Mechanics_text", "Lowroll_title", "");
            Text_body = ini_read_string("Boonbane_text", "Boon_bonus", "") + ini_read_string("Mechanics_text", "Lowroll_body", "") + ini_read_string("Ticket_text", "Bonus_lowroll_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_102:
            Ticket_cost = 9;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Mechanics_text", "Highroll_title", "");
            Text_body = ini_read_string("Boonbane_text", "Boon_bonus", "") + ini_read_string("Mechanics_text", "Highroll_body", "") + ini_read_string("Ticket_text", "Bonus_highroll_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_103:
            Ticket_cost = 9;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Mechanics_text", "Straight_title", "");
            Text_body = ini_read_string("Boonbane_text", "Boon_bonus", "") + ini_read_string("Mechanics_text", "Straight_body", "") + ini_read_string("Ticket_text", "Bonus_straight_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_104:
            Ticket_cost = 9;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Mechanics_text", "Empty_title", "");
            Text_body = ini_read_string("Boonbane_text", "Boon_bonus", "") + ini_read_string("Mechanics_text", "Empty_body", "") + ini_read_string("Ticket_text", "Bonus_empty_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_106:
            Ticket_cost = 12;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Add_play1_title", "");
            Text_body = ini_read_string("Ticket_text", "Add_play1_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_107:
            Ticket_cost = 9;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Add_reroll1_title", "");
            Text_body = ini_read_string("Ticket_text", "Add_reroll1_body", "");
            ini_close();
            break;
        case UnknownEnum.Value_108:
            Ticket_cost = 12;
            ini_open(global.lang_file);
            Text_head = ini_read_string("Ticket_text", "Remove_bane_title", "");
            Text_body = ini_read_string("Ticket_text", "Remove_bane_body", "");
            ini_close();
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
