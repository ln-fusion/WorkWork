function scr_Item_unequip()
{
    for (var var_m = 1; var_m < 7; var_m += 1)
    {
        array_resize(Dice_effect[var_m], 0);
    }
    for (var var_i = 0; var_i < Passive_max; var_i += 1)
    {
        var var_check = 0;
        switch (Passive[var_i])
        {
            case UnknownEnum.Value_0:
                Dice_effect[1] = [["<>", 1]];
                Dice_effect[6] = [["<>", 1]];
                var_check = 1;
                break;
            case UnknownEnum.Value_1:
                Dice_effect[1] = [["$", 1]];
                Dice_effect[2] = [["$", 1]];
                Dice_effect[6] = [["M", 1]];
                var_check = 1;
                break;
            case UnknownEnum.Value_2:
                Dice_effect[1] = [["R", 1]];
                Dice_effect[5] = [["^Add", 1]];
                Dice_effect[6] = [["^Add", 1]];
                break;
            case UnknownEnum.Value_3:
                Dice_effect[2] = [["M", 1]];
                Dice_effect[3] = [["$", 1]];
                Dice_effect[5] = [["M", 1]];
                break;
            case UnknownEnum.Value_4:
                Dice_effect[1] = [["P+", 1]];
                Dice_effect[2] = [["^Add", 1]];
                break;
            case UnknownEnum.Value_5:
                Dice_effect[2] = [["<>", 1]];
                Dice_effect[6] = [["$", 1]];
                break;
            case UnknownEnum.Value_6:
                Dice_effect[1] = [["Spade", 1]];
                Dice_effect[3] = [["Spade", 1]];
                Dice_effect[5] = [["Spade", 1]];
                break;
            case UnknownEnum.Value_7:
                Dice_effect[2] = [["Heart", 1]];
                Dice_effect[4] = [["Heart", 1]];
                Dice_effect[6] = [["Heart", 1]];
                break;
            case UnknownEnum.Value_9:
                Dice_effect[2] = [["Heart", 1]];
                Dice_effect[4] = [["Heart", 1]];
                Dice_effect[6] = [["Heart", 1]];
                break;
            case UnknownEnum.Value_10:
                Dice_effect[1] = [["Spade", 1]];
                Dice_effect[3] = [["Spade", 1]];
                Dice_effect[5] = [["Spade", 1]];
                break;
            case UnknownEnum.Value_11:
                Dice_effect[3] = [["M", 1]];
                Dice_effect[5] = [["M", 1]];
                break;
            case UnknownEnum.Value_12:
                Dice_effect[1] = [["R", 1]];
                Dice_effect[3] = [["^Add", 1]];
                break;
            case UnknownEnum.Value_42:
                Dice_effect[3] = [["SS", 1]];
                break;
            case UnknownEnum.Value_14:
                Dice_effect[1] = [["^Add", 1]];
                Dice_effect[4] = [["^Add", 1]];
                break;
            case UnknownEnum.Value_15:
                Dice_effect[5] = [["Boost", 1]];
                Dice_effect[6] = [["Boost", 1]];
                break;
            case UnknownEnum.Value_16:
                Dice_effect[3] = [["R", 1]];
                Dice_effect[4] = [["R", 1]];
                break;
            case UnknownEnum.Value_17:
                Dice_effect[4] = [["R", 1]];
                Dice_effect[6] = [["R", 1]];
                break;
            case UnknownEnum.Value_18:
                Dice_effect[3] = [["M", 1]];
                Dice_effect[4] = [["M", 1]];
                break;
            case UnknownEnum.Value_19:
                Dice_effect[1] = [["<>", 1]];
                Dice_effect[5] = [["M", 1]];
                break;
            case UnknownEnum.Value_20:
                Dice_effect[6] = [["P+", 1]];
                break;
            case UnknownEnum.Value_21:
                Dice_effect[6] = [["SS", 1]];
                break;
            case UnknownEnum.Value_22:
                Dice_effect[4] = [["Boost", 1]];
                Dice_effect[5] = [["Boost", 1]];
                break;
            case UnknownEnum.Value_23:
                Dice_effect[2] = [["<>", 1]];
                Dice_effect[5] = [["M", 1]];
                break;
            case UnknownEnum.Value_24:
                Dice_effect[6] = [["X2", 1]];
                break;
            case UnknownEnum.Value_25:
                Dice_effect[1] = [["Spade", 1]];
                Dice_effect[2] = [["Heart", 1]];
                Dice_effect[3] = [["Spade", 1]];
                Dice_effect[4] = [["Heart", 1]];
                Dice_effect[5] = [["Spade", 1]];
                Dice_effect[6] = [["Heart", 1]];
                break;
            case UnknownEnum.Value_26:
                Dice_effect[2] = [["SS", 1]];
                Dice_effect[6] = [["R", 1]];
                break;
            case UnknownEnum.Value_27:
                Dice_effect[3] = [["Spade", 1], ["Heart", 1]];
                Dice_effect[6] = [["Spade", 1], ["Heart", 1]];
                break;
            case UnknownEnum.Value_28:
                Dice_effect[4] = [["M", 1]];
                Dice_effect[5] = [["M", 1]];
                Dice_effect[6] = [["M", 1]];
                break;
            case UnknownEnum.Value_29:
                Dice_effect[3] = [["<>", 1]];
                Dice_effect[4] = [["<>", 1]];
                break;
            case UnknownEnum.Value_30:
                Dice_effect[3] = [["M", 1]];
                Dice_effect[4] = [["M", 1]];
                break;
            case UnknownEnum.Value_31:
                Dice_effect[3] = [["$", 1]];
                break;
            case UnknownEnum.Value_32:
                Dice_effect[1] = [["Spade", 1]];
                Dice_effect[2] = [["Spade", 1]];
                Dice_effect[3] = [["Spade", 1]];
                Dice_effect[4] = [["Spade", 1]];
                Dice_effect[5] = [["Spade", 1]];
                Dice_effect[6] = [["Spade", 1]];
                break;
            case UnknownEnum.Value_33:
                Dice_effect[1] = [["Heart", 1]];
                Dice_effect[2] = [["Heart", 1]];
                Dice_effect[3] = [["Heart", 1]];
                Dice_effect[4] = [["Heart", 1]];
                Dice_effect[5] = [["Heart", 1]];
                Dice_effect[6] = [["Heart", 1]];
                break;
            case UnknownEnum.Value_45:
                Dice_effect[2] = [["M", 1]];
                Dice_effect[3] = [["M", 1]];
                break;
            case UnknownEnum.Value_34:
                Dice_effect[1] = [["SS", 1]];
                break;
            case UnknownEnum.Value_35:
                Dice_effect[2] = [["X2", 1]];
                break;
            case UnknownEnum.Value_36:
                Dice_effect[3] = [["X2", 1]];
                break;
            case UnknownEnum.Value_37:
                Dice_effect[4] = [["X2", 1]];
                break;
            case UnknownEnum.Value_38:
                Dice_effect[1] = [["X2", 1]];
                Dice_effect[4] = [["^R", 1]];
                break;
            case UnknownEnum.Value_39:
                Dice_effect[3] = [["<>", 1]];
                Dice_effect[6] = [["<>", 1]];
                break;
            case UnknownEnum.Value_40:
                Dice_effect[1] = [["<>", 1]];
                Dice_effect[2] = [["<>", 1]];
                Dice_effect[3] = [["<>", 1]];
                break;
            case UnknownEnum.Value_41:
                Dice_effect[1] = [["M", 1]];
                Dice_effect[6] = [["M", 1]];
                break;
            case UnknownEnum.Value_13:
                Dice_effect[1] = [["<>", 1]];
                Dice_effect[2] = [["<>", 1]];
                break;
            case UnknownEnum.Value_43:
                Dice_effect[1] = [["X2", 1]];
                break;
            case UnknownEnum.Value_44:
                Dice_effect[3] = [["R", 1]];
                Dice_effect[5] = [["R", 1]];
                break;
            case UnknownEnum.Value_46:
                Dice_effect[3] = [["P+", 1]];
                break;
            case UnknownEnum.Value_47:
                Dice_effect[1] = [["R", 1]];
                Dice_effect[2] = [["R", 1]];
                Dice_effect[5] = [["^Add", 1]];
                break;
            case UnknownEnum.Value_48:
                Dice_effect[1] = [["R", 1]];
                Dice_effect[3] = [["R", 1]];
                Dice_effect[4] = [["^R", 1]];
                break;
            case UnknownEnum.Value_49:
                Dice_effect[2] = [["P+", 1]];
                Dice_effect[5] = [["P+", 1]];
                break;
            case UnknownEnum.Value_50:
                Dice_effect[2] = [["D", 1]];
                Dice_effect[4] = [["D", 1]];
                break;
            case UnknownEnum.Value_51:
                Dice_effect[4] = [["Boost", 1]];
                Dice_effect[5] = [["Boost", 1]];
                break;
            case UnknownEnum.Value_52:
                Dice_effect[2] = [["SS", 1]];
                Dice_effect[4] = [["SS", 1]];
                break;
            case UnknownEnum.Value_53:
                Dice_effect[1] = [["SS", 1]];
                Dice_effect[5] = [["SS", 1]];
                break;
            case UnknownEnum.Value_54:
                Dice_effect[1] = [["D", 1]];
                Dice_effect[5] = [["D", 1]];
                break;
            case UnknownEnum.Value_55:
                Dice_effect[3] = [["X2", 1]];
                Dice_effect[4] = [["X2", 1]];
                break;
            case UnknownEnum.Value_56:
                Dice_effect[1] = [["X2", 1]];
                break;
        }
        if (var_check == 0)
        {
            scr_Item_setup(Passive[var_i], var_i);
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
    Value_7,
    Value_9 = 9,
    Value_10,
    Value_11,
    Value_12,
    Value_13,
    Value_14,
    Value_15,
    Value_16,
    Value_17,
    Value_18,
    Value_19,
    Value_20,
    Value_21,
    Value_22,
    Value_23,
    Value_24,
    Value_25,
    Value_26,
    Value_27,
    Value_28,
    Value_29,
    Value_30,
    Value_31,
    Value_32,
    Value_33,
    Value_34,
    Value_35,
    Value_36,
    Value_37,
    Value_38,
    Value_39,
    Value_40,
    Value_41,
    Value_42,
    Value_43,
    Value_44,
    Value_45,
    Value_46,
    Value_47,
    Value_48,
    Value_49,
    Value_50,
    Value_51,
    Value_52,
    Value_53,
    Value_54,
    Value_55,
    Value_56
}
