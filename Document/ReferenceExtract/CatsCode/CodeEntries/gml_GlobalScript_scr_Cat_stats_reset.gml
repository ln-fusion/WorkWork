function scr_Cat_stats_reset(arg0, arg1)
{
    for (var var_i = 0; var_i < Passive_max; var_i += 1)
    {
        Cat_sunstone[var_i] = 0;
    }
    switch (arg0)
    {
        case UnknownEnum.Value_1:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_2:
            Cat_chips[arg1] = 6 + Passive_increase;
            break;
        case UnknownEnum.Value_3:
            Cat_mult[arg1] = 7 + Passive_increase;
            break;
        case UnknownEnum.Value_4:
            Cat_chips[arg1] = 11 + Passive_increase;
            Cat_mult[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_6:
            Cat_mult[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_7:
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_9:
            Cat_mult[arg1] = 4 + Passive_increase;
            break;
        case UnknownEnum.Value_10:
            Cat_mult[arg1] = 5 + Passive_increase;
            break;
        case UnknownEnum.Value_12:
            Cat_chips[arg1] = 30 + Passive_increase;
            break;
        case UnknownEnum.Value_14:
            Cat_chips[arg1] = 120 + Passive_increase;
            break;
        case UnknownEnum.Value_15:
            Cat_num[arg1] = 6 + Passive_increase;
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_16:
            Cat_num[arg1] = 0 + Passive_increase;
            Cat_chips[arg1] = 100 + Passive_increase;
            break;
        case UnknownEnum.Value_17:
            Cat_chips[arg1] = 30 + Passive_increase;
            break;
        case UnknownEnum.Value_18:
            Cat_num[arg1] = 0 + Passive_increase;
            Cat_mult[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_19:
            Cat_num[arg1] = 1 + Passive_increase;
            Cat_chips[arg1] = 12 + Passive_increase;
            break;
        case UnknownEnum.Value_20:
            Cat_chips[arg1] = 40 + Passive_increase;
            break;
        case UnknownEnum.Value_21:
            Cat_chips[arg1] = 40 + Passive_increase;
            break;
        case UnknownEnum.Value_22:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_24:
            Cat_num[arg1] = 2 + Passive_increase;
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_26:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_28:
            Cat_num[arg1] = 6 + Passive_increase;
            break;
        case UnknownEnum.Value_34:
            Cat_mult[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_35:
            Cat_mult[arg1] = 1 + Passive_increase;
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_36:
            Cat_mult[arg1] = 1 + Passive_increase;
            Cat_num[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_37:
            Cat_mult[arg1] = 4 + Passive_increase;
            Cat_num[arg1] = 4 + Passive_increase;
            break;
        case UnknownEnum.Value_38:
            Cat_mult[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_39:
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_40:
            Cat_num[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_41:
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_43:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_44:
            Cat_num[arg1] = 1 + Passive_increase;
            Cat_mult[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_46:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_47:
            Cat_chips[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_48:
            Cat_num[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_49:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_50:
            Cat_mult[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_53:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_54:
            Cat_num[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_55:
            Cat_mult[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_1000:
            Cat_mult[arg1] = 4 + Passive_increase;
            break;
        case UnknownEnum.Value_1001:
            Cat_mult[arg1] = 6 + Passive_increase;
            break;
        case UnknownEnum.Value_1003:
            Cat_num[arg1] = 18 + Passive_increase;
            Cat_mult[arg1] = 10 + Passive_increase;
            break;
        case UnknownEnum.Value_1004:
            Cat_num[arg1] = 30 + Passive_increase;
            Cat_mult[arg1] = 9 + Passive_increase;
            break;
        case UnknownEnum.Value_1006:
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_1007:
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_1008:
            Cat_mult[arg1] = 9 + Passive_increase;
            break;
        case UnknownEnum.Value_1009:
            Cat_mult[arg1] = 10 + Passive_increase;
            break;
        case UnknownEnum.Value_1010:
            Cat_chips[arg1] = 21 + Passive_increase;
            break;
        case UnknownEnum.Value_1011:
            Cat_chips[arg1] = 8 + Passive_increase;
            break;
        case UnknownEnum.Value_1012:
            Cat_chips[arg1] = 8 + Passive_increase;
            break;
        case UnknownEnum.Value_1013:
            Cat_chips[arg1] = 39 + Passive_increase;
            break;
        case UnknownEnum.Value_1014:
            Cat_chips[arg1] = 36 + Passive_increase;
            break;
        case UnknownEnum.Value_1016:
            Cat_chips[arg1] = 50 + Passive_increase;
            break;
        case UnknownEnum.Value_1017:
            Cat_num[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_1018:
            Cat_num[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_1019:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_1020:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_1021:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_1022:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_2000:
            Cat_num[arg1] = 7 + Passive_increase;
            Cat_mult[arg1] = 12 + Passive_increase;
            break;
        case UnknownEnum.Value_2001:
            Cat_mult[arg1] = 12 + Passive_increase;
            break;
        case UnknownEnum.Value_2002:
            Cat_mult[arg1] = 12 + Passive_increase;
            break;
        case UnknownEnum.Value_2004:
            Cat_chips[arg1] = 100 + Passive_increase;
            Cat_num[arg1] = 10 + Passive_increase;
            break;
        case UnknownEnum.Value_2005:
            Cat_chips[arg1] = 70 + Passive_increase;
            break;
        case UnknownEnum.Value_2006:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_2007:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_2008:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_2009:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_2010:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_2011:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_2012:
            Cat_chips[arg1] = 3 + Passive_increase;
            break;
        case UnknownEnum.Value_3000:
            Cat_mult[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_3001:
            Cat_chips[arg1] = 9 + Passive_increase;
            break;
        case UnknownEnum.Value_3002:
            Cat_mult[arg1] = 1.5 + Passive_increase;
            break;
        case UnknownEnum.Value_3003:
            Cat_num[arg1] = 2 + Passive_increase;
            break;
        case UnknownEnum.Value_3004:
            Cat_num[arg1] = 1 + Passive_increase;
            break;
        case UnknownEnum.Value_3005:
            Cat_chips[arg1] = 6 + Passive_increase;
            Cat_mult[arg1] = 6 + Passive_increase;
            Cat_num[arg1] = 6 + Passive_increase;
            break;
    }
}

enum UnknownEnum
{
    Value_1 = 1,
    Value_2,
    Value_3,
    Value_4,
    Value_6 = 6,
    Value_7,
    Value_9 = 9,
    Value_10,
    Value_12 = 12,
    Value_14 = 14,
    Value_15,
    Value_16,
    Value_17,
    Value_18,
    Value_19,
    Value_20,
    Value_21,
    Value_22,
    Value_24 = 24,
    Value_26 = 26,
    Value_28 = 28,
    Value_34 = 34,
    Value_35,
    Value_36,
    Value_37,
    Value_38,
    Value_39,
    Value_40,
    Value_41,
    Value_43 = 43,
    Value_44,
    Value_46 = 46,
    Value_47,
    Value_48,
    Value_49,
    Value_50,
    Value_53 = 53,
    Value_54,
    Value_55,
    Value_1000 = 1000,
    Value_1001,
    Value_1003 = 1003,
    Value_1004,
    Value_1006 = 1006,
    Value_1007,
    Value_1008,
    Value_1009,
    Value_1010,
    Value_1011,
    Value_1012,
    Value_1013,
    Value_1014,
    Value_1016 = 1016,
    Value_1017,
    Value_1018,
    Value_1019,
    Value_1020,
    Value_1021,
    Value_1022,
    Value_2000 = 2000,
    Value_2001,
    Value_2002,
    Value_2004 = 2004,
    Value_2005,
    Value_2006,
    Value_2007,
    Value_2008,
    Value_2009,
    Value_2010,
    Value_2011,
    Value_2012,
    Value_3000 = 3000,
    Value_3001,
    Value_3002,
    Value_3003,
    Value_3004,
    Value_3005
}
