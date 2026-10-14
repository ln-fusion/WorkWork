function scr_Item_setup(arg0, arg1)
{
    switch (arg0)
    {
        case UnknownEnum.Value_1000:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_mult = 4;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "MouseKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "MouseKeychain_passive", "");
                ini_close();
                subimg = 0;
            }
            else
            {
                Cat_mult[arg1] = 4;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "MouseKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1001:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_mult = 6;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "WhaleKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "WhaleKeychain_passive", "");
                ini_close();
                subimg = 1;
            }
            else
            {
                Cat_mult[arg1] = 6;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "WhaleKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1002:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "ParrotKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "ParrotKeychain_passive", "");
                ini_close();
                subimg = 2;
            }
            else
            {
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "ParrotKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1003:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_num = 18;
                Item_mult = 10;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "AcornKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "AcornKeychain_passive", "");
                ini_close();
                subimg = 3;
            }
            else
            {
                Cat_num[arg1] = 18;
                Cat_mult[arg1] = 10;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "AcornKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1004:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_num = 30;
                Item_mult = 9;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoconutKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "CoconutKeychain_passive", "");
                ini_close();
                subimg = 4;
            }
            else
            {
                Cat_num[arg1] = 30;
                Cat_mult[arg1] = 9;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoconutKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1005:
            if (arg1 == -4)
            {
                Item_cost = 4;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlobKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "BlobKeychain_passive", "");
                ini_close();
                subimg = 5;
            }
            else
            {
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlobKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1006:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_mult = 2;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "DeerKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "DeerKeychain_passive", "");
                ini_close();
                subimg = 6;
            }
            else
            {
                Cat_mult[arg1] = 2;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "DeerKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1007:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_mult = 2;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "WolfKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "WolfKeychain_passive", "");
                ini_close();
                subimg = 7;
            }
            else
            {
                Cat_mult[arg1] = 2;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "WolfKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1008:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_mult = 9;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "TriangleKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "TriangleKeychain_passive", "");
                ini_close();
                subimg = 8;
            }
            else
            {
                Cat_mult[arg1] = 9;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "TriangleKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1009:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_mult = 10;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "SquareKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "SquareKeychain_passive", "");
                ini_close();
                subimg = 9;
            }
            else
            {
                Cat_mult[arg1] = 10;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "SquareKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1010:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_chips = 21;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "DogSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "DogSticker_passive", "");
                ini_close();
                subimg = 10;
            }
            else
            {
                Cat_chips[arg1] = 21;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "DogSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1011:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_chips = 8;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "DeerSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "DeerSticker_passive", "");
                ini_close();
                subimg = 11;
            }
            else
            {
                Cat_chips[arg1] = 8;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "DeerSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1012:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_chips = 8;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "WolfSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "WolfSticker_passive", "");
                ini_close();
                subimg = 12;
            }
            else
            {
                Cat_chips[arg1] = 8;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "WolfSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1013:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_chips = 39;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "TriangleSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "TriangleSticker_passive", "");
                ini_close();
                subimg = 13;
            }
            else
            {
                Cat_chips[arg1] = 39;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "TriangleSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1014:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_chips = 36;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "SquareSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "SquareSticker_passive", "");
                ini_close();
                subimg = 14;
            }
            else
            {
                Cat_chips[arg1] = 36;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "SquareSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1015:
            if (arg1 == -4)
            {
                Item_cost = 4;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrowSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "CrowSticker_passive", "");
                ini_close();
                subimg = 15;
            }
            else
            {
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrowSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1016:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_chips = 50;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "HawkSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "HawkSticker_passive", "");
                ini_close();
                subimg = 16;
            }
            else
            {
                Cat_chips[arg1] = 50;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "HawkSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1017:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_num = 2;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Purse_title", "");
                Text_Passive = ini_read_string("Item_text", "Purse_passive", "");
                ini_close();
                subimg = 17;
            }
            else
            {
                Cat_num[arg1] = 2;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Purse_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1018:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_num = 2;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Wallet_title", "");
                Text_Passive = ini_read_string("Item_text", "Wallet_passive", "");
                ini_close();
                subimg = 18;
            }
            else
            {
                Cat_num[arg1] = 2;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Wallet_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1019:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Item_num = 1;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RightJab_title", "");
                Text_Passive = ini_read_string("Item_text", "RightJab_passive", "");
                ini_close();
                subimg = 19;
            }
            else
            {
                Cat_num[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RightJab_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1020:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_num = 1;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "YarnBall_title", "");
                Text_Passive = ini_read_string("Item_text", "YarnBall_passive", "");
                ini_close();
                subimg = 20;
            }
            else
            {
                Cat_num[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "YarnBall_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1021:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_num = 1;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Whetstone_title", "");
                Text_Passive = ini_read_string("Item_text", "Whetstone_passive", "");
                ini_close();
                subimg = 21;
            }
            else
            {
                Cat_num[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Whetstone_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1022:
            if (arg1 == -4)
            {
                Item_cost = 3;
                Item_num = 1;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Sandpaper_title", "");
                Text_Passive = ini_read_string("Item_text", "Sandpaper_passive", "");
                ini_close();
                subimg = 22;
            }
            else
            {
                Cat_num[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Sandpaper_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1023:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CloverONE_title", "");
                Text_Passive = ini_read_string("Item_text", "CloverONE_passive", "");
                ini_close();
                subimg = 23;
            }
            else
            {
                Passive_skip[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CloverONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1024:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CloverTWO_title", "");
                Text_Passive = ini_read_string("Item_text", "CloverTWO_passive", "");
                ini_close();
                subimg = 24;
            }
            else
            {
                Passive_skip[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CloverTWO_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1025:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CloverTHREE_title", "");
                Text_Passive = ini_read_string("Item_text", "CloverTHREE_passive", "");
                ini_close();
                subimg = 25;
            }
            else
            {
                Passive_skip[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CloverTHREE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1026:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CloverFOUR_title", "");
                Text_Passive = ini_read_string("Item_text", "CloverFOUR_passive", "");
                ini_close();
                subimg = 26;
            }
            else
            {
                Passive_skip[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CloverFOUR_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1027:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CloverFIVE_title", "");
                Text_Passive = ini_read_string("Item_text", "CloverFIVE_passive", "");
                ini_close();
                subimg = 27;
            }
            else
            {
                Passive_skip[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CloverFIVE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1028:
            if (arg1 == -4)
            {
                Item_cost = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CloverSIX_title", "");
                Text_Passive = ini_read_string("Item_text", "CloverSIX_passive", "");
                ini_close();
                subimg = 28;
            }
            else
            {
                Passive_skip[arg1] = 1;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CloverSIX_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1100:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["<>", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlingONE_title", "");
                Text_Passive = ini_read_string("Item_text", "BlingONE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 0;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[1]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[1]); var_i += 1)
                    {
                        switch (Dice_effect[1][var_i][0])
                        {
                            case "<>":
                                array_set(Dice_effect[1][var_i], 1, Dice_effect[1][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[1], ["<>", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlingONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1101:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["<>", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlingTWO_title", "");
                Text_Passive = ini_read_string("Item_text", "BlingTWO_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 1;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[2]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[2]); var_i += 1)
                    {
                        switch (Dice_effect[2][var_i][0])
                        {
                            case "<>":
                                array_set(Dice_effect[2][var_i], 1, Dice_effect[2][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[2], ["<>", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlingTWO_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1102:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["<>", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlingTHREE_title", "");
                Text_Passive = ini_read_string("Item_text", "BlingTHREE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 2;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[3]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[3]); var_i += 1)
                    {
                        switch (Dice_effect[3][var_i][0])
                        {
                            case "<>":
                                array_set(Dice_effect[3][var_i], 1, Dice_effect[3][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[3], ["<>", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlingONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1103:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["<>", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlingFOUR_title", "");
                Text_Passive = ini_read_string("Item_text", "BlingFOUR_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 3;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[4]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[4]); var_i += 1)
                    {
                        switch (Dice_effect[4][var_i][0])
                        {
                            case "<>":
                                array_set(Dice_effect[4][var_i], 1, Dice_effect[4][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[4], ["<>", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlingFOUR_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1104:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["<>", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlingFIVE_title", "");
                Text_Passive = ini_read_string("Item_text", "BlingFIVE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 4;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[5]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[5]); var_i += 1)
                    {
                        switch (Dice_effect[5][var_i][0])
                        {
                            case "<>":
                                array_set(Dice_effect[5][var_i], 1, Dice_effect[5][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[5], ["<>", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlingFIVE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1105:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["<>", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlingSIX_title", "");
                Text_Passive = ini_read_string("Item_text", "BlingSIX_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 5;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[6]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[6]); var_i += 1)
                    {
                        switch (Dice_effect[6][var_i][0])
                        {
                            case "<>":
                                array_set(Dice_effect[6][var_i], 1, Dice_effect[6][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[6], ["<>", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlingSIX_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1106:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["M", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrossONE_title", "");
                Text_Passive = ini_read_string("Item_text", "CrossONE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 6;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[1]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[1]); var_i += 1)
                    {
                        switch (Dice_effect[1][var_i][0])
                        {
                            case "M":
                                array_set(Dice_effect[1][var_i], 1, Dice_effect[1][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[1], ["M", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrossONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1107:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["M", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrossTWO_title", "");
                Text_Passive = ini_read_string("Item_text", "CrossTWO_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 7;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[2]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[2]); var_i += 1)
                    {
                        switch (Dice_effect[2][var_i][0])
                        {
                            case "M":
                                array_set(Dice_effect[2][var_i], 1, Dice_effect[2][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[2], ["M", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrossTWO_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1108:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["M", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrossTHREE_title", "");
                Text_Passive = ini_read_string("Item_text", "CrossTHREE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 8;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[3]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[3]); var_i += 1)
                    {
                        switch (Dice_effect[3][var_i][0])
                        {
                            case "M":
                                array_set(Dice_effect[3][var_i], 1, Dice_effect[3][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[3], ["M", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrossTHREE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1109:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["M", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrossFOUR_title", "");
                Text_Passive = ini_read_string("Item_text", "CrossFOUR_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 9;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[4]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[4]); var_i += 1)
                    {
                        switch (Dice_effect[4][var_i][0])
                        {
                            case "M":
                                array_set(Dice_effect[4][var_i], 1, Dice_effect[4][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[4], ["M", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrossFOUR_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1110:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["M", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrossFIVE_title", "");
                Text_Passive = ini_read_string("Item_text", "CrossFIVE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 10;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[5]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[5]); var_i += 1)
                    {
                        switch (Dice_effect[5][var_i][0])
                        {
                            case "M":
                                array_set(Dice_effect[5][var_i], 1, Dice_effect[5][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[5], ["M", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrossFIVE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1111:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["M", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CrossSIX_title", "");
                Text_Passive = ini_read_string("Item_text", "CrossSIX_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 11;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[6]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[6]); var_i += 1)
                    {
                        switch (Dice_effect[6][var_i][0])
                        {
                            case "M":
                                array_set(Dice_effect[6][var_i], 1, Dice_effect[6][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[6], ["M", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CrossSIX_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1112:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["$", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoinONE_title", "");
                Text_Passive = ini_read_string("Item_text", "CoinONE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 12;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[1]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[1]); var_i += 1)
                    {
                        switch (Dice_effect[1][var_i][0])
                        {
                            case "$":
                                array_set(Dice_effect[1][var_i], 1, Dice_effect[1][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[1], ["$", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoinONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1113:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["$", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoinTWO_title", "");
                Text_Passive = ini_read_string("Item_text", "CoinTWO_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 13;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[2]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[2]); var_i += 1)
                    {
                        switch (Dice_effect[2][var_i][0])
                        {
                            case "$":
                                array_set(Dice_effect[2][var_i], 1, Dice_effect[2][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[2], ["$", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoinTWO_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1114:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["$", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoinTHREE_title", "");
                Text_Passive = ini_read_string("Item_text", "CoinTHREE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 14;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[3]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[3]); var_i += 1)
                    {
                        switch (Dice_effect[3][var_i][0])
                        {
                            case "$":
                                array_set(Dice_effect[3][var_i], 1, Dice_effect[3][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[3], ["$", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoinTHREE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1115:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["$", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoinFOUR_title", "");
                Text_Passive = ini_read_string("Item_text", "CoinFOUR_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 15;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[4]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[4]); var_i += 1)
                    {
                        switch (Dice_effect[4][var_i][0])
                        {
                            case "$":
                                array_set(Dice_effect[4][var_i], 1, Dice_effect[4][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[4], ["$", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoinFOUR_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1116:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["$", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoinFIVE_title", "");
                Text_Passive = ini_read_string("Item_text", "CoinFIVE_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 16;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[5]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[5]); var_i += 1)
                    {
                        switch (Dice_effect[5][var_i][0])
                        {
                            case "$":
                                array_set(Dice_effect[5][var_i], 1, Dice_effect[5][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[5], ["$", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoinFIVE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_1117:
            if (arg1 == -4)
            {
                Item_cost = 4;
                Dice_effect = [["$", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "CoinSIX_title", "");
                Text_Passive = ini_read_string("Item_text", "CoinSIX_passive", "");
                ini_close();
                currentspr = spr_Item_common2;
                subimg = 17;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[6]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[6]); var_i += 1)
                    {
                        switch (Dice_effect[6][var_i][0])
                        {
                            case "$":
                                array_set(Dice_effect[6][var_i], 1, Dice_effect[6][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[6], ["$", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "CoinSIX_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2000:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Item_num = 7;
                Item_mult = 12;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "GiraffeKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "GiraffeKeychain_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 0;
            }
            else
            {
                Cat_num[arg1] = 7;
                Cat_mult[arg1] = 12;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "GiraffeKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2001:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Item_mult = 12;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "NeedletailKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "NeedletailKeychain_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 1;
            }
            else
            {
                Cat_mult[arg1] = 12;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "NeedletailKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2002:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Item_mult = 12;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "NailKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "NailKeychain_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 2;
            }
            else
            {
                Cat_mult[arg1] = 12;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "NailKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2003:
            if (arg1 == -4)
            {
                Item_cost = 6;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "ElephantSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "ElephantSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 3;
            }
            else
            {
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "ElephantSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2004:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 100;
                Item_num = 10;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "AntSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "AntSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 4;
            }
            else
            {
                Cat_chips[arg1] = 100;
                Cat_num[arg1] = 10;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "AntSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2005:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Item_chips = 70;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "TortoiseSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "TortoiseSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 5;
            }
            else
            {
                Cat_chips[arg1] = 70;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "TortoiseSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2006:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "ONESticker_title", "");
                Text_Passive = ini_read_string("Item_text", "ONESticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 6;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "ONESticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2007:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "TWOSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "TWOSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 7;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "TWOSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2008:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "THREESticker_title", "");
                Text_Passive = ini_read_string("Item_text", "THREESticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 8;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "THREESticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2009:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "FOURSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "FOURSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 9;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "FOURSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2010:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "FIVESticker_title", "");
                Text_Passive = ini_read_string("Item_text", "FIVESticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 10;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "FIVESticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2011:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "SIXSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "SIXSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 11;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "SIXSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2012:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Item_chips = 3;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "ZEROSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "ZEROSticker_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 12;
            }
            else
            {
                Cat_chips[arg1] = 3;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "ZEROSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2015:
            if (arg1 == -4)
            {
                Item_cost = 7;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Magnet_title", "");
                Text_Passive = ini_read_string("Item_text", "Magnet_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 13;
            }
            else
            {
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Magnet_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2016:
            if (arg1 == -4)
            {
                Item_cost = 7;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "ClawMachine_title", "");
                Text_Passive = ini_read_string("Item_text", "ClawMachine_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon;
                subimg = 14;
            }
            else
            {
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "ClawMachine_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2101:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Dice_effect = [["R", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "MarbleBall_title", "");
                Text_Passive = ini_read_string("Item_text", "MarbleBall_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 1;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                for (var var_i = 1; var_i < 7; var_i += 1)
                {
                    var_check = 0;
                    if (array_length(Dice_effect[var_i]) > 0)
                    {
                        for (var var_j = 0; var_j < array_length(Dice_effect[var_i]); var_j += 1)
                        {
                            switch (Dice_effect[var_i][var_j][0])
                            {
                                case "R":
                                    array_set(Dice_effect[var_i][var_j], 1, Dice_effect[var_i][var_j][1] + 1);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[var_i], ["R", 1]);
                    }
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "MarbleBall_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2102:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Dice_effect = [["Boost", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RocketONE_title", "");
                Text_Passive = ini_read_string("Item_text", "RocketONE_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 2;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[1]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[1]); var_i += 1)
                    {
                        switch (Dice_effect[1][var_i][0])
                        {
                            case "Boost":
                                array_set(Dice_effect[1][var_i], 1, Dice_effect[1][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[1], ["Boost", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RocketONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2103:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Dice_effect = [["Boost", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RocketTWO_title", "");
                Text_Passive = ini_read_string("Item_text", "RocketTWO_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 3;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[2]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[2]); var_i += 1)
                    {
                        switch (Dice_effect[2][var_i][0])
                        {
                            case "Boost":
                                array_set(Dice_effect[2][var_i], 1, Dice_effect[2][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[2], ["Boost", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RocketTWO_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2104:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Dice_effect = [["Boost", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RocketTHREE_title", "");
                Text_Passive = ini_read_string("Item_text", "RocketTHREE_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 4;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[3]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[3]); var_i += 1)
                    {
                        switch (Dice_effect[3][var_i][0])
                        {
                            case "Boost":
                                array_set(Dice_effect[3][var_i], 1, Dice_effect[3][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[3], ["Boost", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RocketTHREE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2105:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Dice_effect = [["Boost", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RocketFOUR_title", "");
                Text_Passive = ini_read_string("Item_text", "RocketFOUR_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 5;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[4]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[4]); var_i += 1)
                    {
                        switch (Dice_effect[4][var_i][0])
                        {
                            case "Boost":
                                array_set(Dice_effect[4][var_i], 1, Dice_effect[4][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[4], ["Boost", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RocketFOUR_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2106:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Dice_effect = [["Boost", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RocketFIVE_title", "");
                Text_Passive = ini_read_string("Item_text", "RocketFIVE_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 6;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[5]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[5]); var_i += 1)
                    {
                        switch (Dice_effect[5][var_i][0])
                        {
                            case "Boost":
                                array_set(Dice_effect[5][var_i], 1, Dice_effect[5][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[5], ["Boost", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RocketFIVE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2107:
            if (arg1 == -4)
            {
                Item_cost = 6;
                Dice_effect = [["Boost", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RocketSIX_title", "");
                Text_Passive = ini_read_string("Item_text", "RocketSIX_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 7;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[6]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[6]); var_i += 1)
                    {
                        switch (Dice_effect[6][var_i][0])
                        {
                            case "Boost":
                                array_set(Dice_effect[6][var_i], 1, Dice_effect[6][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[6], ["Boost", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RocketSIX_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2108:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Dice_effect = [["Spade", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BlackCard_title", "");
                Text_Passive = ini_read_string("Item_text", "BlackCard_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 8;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                for (var var_j = 1; var_j < 6; var_j += 2)
                {
                    var_check = 0;
                    if (array_length(Dice_effect[var_j]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[var_j]); var_i += 1)
                        {
                            switch (Dice_effect[var_j][var_i][0])
                            {
                                case "Spade":
                                    array_set(Dice_effect[var_j][var_i], 1, Dice_effect[var_j][var_i][1] + 1);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[var_j], ["Spade", 1]);
                    }
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BlackCard_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_2109:
            if (arg1 == -4)
            {
                Item_cost = 7;
                Dice_effect = [["Heart", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "RedCard_title", "");
                Text_Passive = ini_read_string("Item_text", "RedCard_passive", "");
                ini_close();
                currentspr = spr_Item_uncommon2;
                subimg = 9;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                for (var var_j = 2; var_j < 7; var_j += 2)
                {
                    var_check = 0;
                    if (array_length(Dice_effect[var_j]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[var_j]); var_i += 1)
                        {
                            switch (Dice_effect[var_j][var_i][0])
                            {
                                case "Heart":
                                    array_set(Dice_effect[var_j][var_i], 1, Dice_effect[var_j][var_i][1] + 1);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[var_j], ["Heart", 1]);
                    }
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "RedCard_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3000:
            if (arg1 == -4)
            {
                Item_cost = 11;
                Item_mult = 2;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "GeckoKeychain_title", "");
                Text_Passive = ini_read_string("Item_text", "GeckoKeychain_passive", "");
                ini_close();
                currentspr = spr_Item_rare;
                subimg = 0;
            }
            else
            {
                Cat_mult[arg1] = 2;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "GeckoKeychain_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3001:
            if (arg1 == -4)
            {
                Item_cost = 11;
                Item_chips = 9;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "GeckoSticker_title", "");
                Text_Passive = ini_read_string("Item_text", "GeckoSticker_passive", "");
                ini_close();
                currentspr = spr_Item_rare;
                subimg = 1;
            }
            else
            {
                Cat_chips[arg1] = 9;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "GeckoSticker_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3002:
            if (arg1 == -4)
            {
                Item_cost = 12;
                Item_mult = 1.5;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "DiamondRing_title", "");
                Text_Passive = ini_read_string("Item_text", "DiamondRing_passive", "");
                ini_close();
                currentspr = spr_Item_rare;
                subimg = 2;
            }
            else
            {
                Cat_mult[arg1] = 1.5;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "DiamondRing_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3003:
            if (arg1 == -4)
            {
                Item_cost = 12;
                Item_num = 2;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "ShinyMedal_title", "");
                Text_Passive = ini_read_string("Item_text", "ShinyMedal_passive", "");
                ini_close();
                currentspr = spr_Item_rare;
                subimg = 3;
            }
            else
            {
                Cat_num[arg1] = 2;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "ShinyMedal_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3004:
            if (arg1 == -4)
            {
                Item_cost = 12;
                Item_num = 1;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Sunstone_title", "");
                Text_Passive = ini_read_string("Item_text", "Sunstone_passive", "");
                ini_close();
                currentspr = spr_Item_rare;
                subimg = 4;
            }
            else
            {
                Cat_num[arg1] = 1;
                for (var var_i = 0; var_i < arg1; var_i += 1)
                {
                    if (Cat_num[var_i] >= 0)
                    {
                        Cat_num[var_i] += Cat_num[arg1];
                    }
                    if (Cat_chips[var_i] >= 0)
                    {
                        Cat_chips[var_i] += Cat_num[arg1];
                    }
                    if (Cat_mult[var_i] >= 0)
                    {
                        Cat_mult[var_i] += Cat_num[arg1];
                    }
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Sunstone_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3005:
            if (arg1 == -4)
            {
                Item_cost = 12;
                Item_chips = 6;
                Item_mult = 6;
                Item_num = 6;
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Goat_title", "");
                Text_Passive = ini_read_string("Item_text", "Goat_passive", "");
                ini_close();
                currentspr = spr_Item_rare;
                subimg = 5;
            }
            else
            {
                Cat_chips[arg1] = 6;
                Cat_mult[arg1] = 6;
                Cat_num[arg1] = 6;
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Goat_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3100:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["^R", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "SpinningTop_title", "");
                Text_Passive = ini_read_string("Item_text", "SpinningTop_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 0;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[4]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[4]); var_i += 1)
                    {
                        switch (Dice_effect[4][var_i][0])
                        {
                            case "^R":
                                array_set(Dice_effect[4][var_i], 1, Dice_effect[4][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[4], ["^R", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "SpinningTop_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3101:
            if (arg1 == -4)
            {
                Item_cost = 12;
                Dice_effect = [["SS", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "Matryoshka_title", "");
                Text_Passive = ini_read_string("Item_text", "Matryoshka_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 1;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                for (var var_i = 1; var_i < 7; var_i += 1)
                {
                    var_check = 0;
                    if (array_length(Dice_effect[var_i]) > 0)
                    {
                        var_check = 1;
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[var_i], ["SS", 1]);
                    }
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "Matryoshka_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3102:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["X2", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BifoldONE_title", "");
                Text_Passive = ini_read_string("Item_text", "BifoldONE_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 2;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[1]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[1]); var_i += 1)
                    {
                        switch (Dice_effect[1][var_i][0])
                        {
                            case "X2":
                                array_set(Dice_effect[1][var_i], 1, Dice_effect[1][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[1], ["X2", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BifoldONE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3103:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["X2", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BifoldTWO_title", "");
                Text_Passive = ini_read_string("Item_text", "BifoldTWO_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 3;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[2]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[2]); var_i += 1)
                    {
                        switch (Dice_effect[2][var_i][0])
                        {
                            case "X2":
                                array_set(Dice_effect[2][var_i], 1, Dice_effect[2][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[2], ["X2", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BifoldTWO_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3104:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["X2", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BifoldTHREE_title", "");
                Text_Passive = ini_read_string("Item_text", "BifoldTHREE_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 4;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[3]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[3]); var_i += 1)
                    {
                        switch (Dice_effect[3][var_i][0])
                        {
                            case "X2":
                                array_set(Dice_effect[3][var_i], 1, Dice_effect[3][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[3], ["X2", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BifoldTHREE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3105:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["X2", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BifoldFOUR_title", "");
                Text_Passive = ini_read_string("Item_text", "BifoldFOUR_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 5;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[4]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[4]); var_i += 1)
                    {
                        switch (Dice_effect[4][var_i][0])
                        {
                            case "X2":
                                array_set(Dice_effect[4][var_i], 1, Dice_effect[4][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[4], ["X2", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BifoldFOUR_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3106:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["X2", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BifoldFIVE_title", "");
                Text_Passive = ini_read_string("Item_text", "BifoldFIVE_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 6;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[5]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[5]); var_i += 1)
                    {
                        switch (Dice_effect[5][var_i][0])
                        {
                            case "X2":
                                array_set(Dice_effect[5][var_i], 1, Dice_effect[5][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[5], ["X2", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BifoldFIVE_passive", "");
                ini_close();
            }
            break;
        case UnknownEnum.Value_3107:
            if (arg1 == -4)
            {
                Item_cost = 10;
                Dice_effect = [["X2", 1]];
                ini_open(global.lang_file);
                Text_Item = ini_read_string("Item_text", "BifoldSIX_title", "");
                Text_Passive = ini_read_string("Item_text", "BifoldSIX_passive", "");
                ini_close();
                currentspr = spr_Item_rare2;
                subimg = 7;
            }
            else
            {
                Passive_skip[arg1] = 1;
                var var_check = 0;
                if (array_length(Dice_effect[6]) > 0)
                {
                    for (var var_i = 0; var_i < array_length(Dice_effect[6]); var_i += 1)
                    {
                        switch (Dice_effect[6][var_i][0])
                        {
                            case "X2":
                                array_set(Dice_effect[6][var_i], 1, Dice_effect[6][var_i][1] + 1);
                                var_check = 1;
                                break;
                        }
                    }
                }
                if (var_check == 0)
                {
                    array_push(Dice_effect[6], ["X2", 1]);
                }
                ini_open(global.lang_file);
                Text_Passive[arg1] = ini_read_string("Item_text", "BifoldSIX_passive", "");
                ini_close();
            }
            break;
    }
}

enum UnknownEnum
{
    Value_1000 = 1000,
    Value_1001,
    Value_1002,
    Value_1003,
    Value_1004,
    Value_1005,
    Value_1006,
    Value_1007,
    Value_1008,
    Value_1009,
    Value_1010,
    Value_1011,
    Value_1012,
    Value_1013,
    Value_1014,
    Value_1015,
    Value_1016,
    Value_1017,
    Value_1018,
    Value_1019,
    Value_1020,
    Value_1021,
    Value_1022,
    Value_1023,
    Value_1024,
    Value_1025,
    Value_1026,
    Value_1027,
    Value_1028,
    Value_1100 = 1100,
    Value_1101,
    Value_1102,
    Value_1103,
    Value_1104,
    Value_1105,
    Value_1106,
    Value_1107,
    Value_1108,
    Value_1109,
    Value_1110,
    Value_1111,
    Value_1112,
    Value_1113,
    Value_1114,
    Value_1115,
    Value_1116,
    Value_1117,
    Value_2000 = 2000,
    Value_2001,
    Value_2002,
    Value_2003,
    Value_2004,
    Value_2005,
    Value_2006,
    Value_2007,
    Value_2008,
    Value_2009,
    Value_2010,
    Value_2011,
    Value_2012,
    Value_2015 = 2015,
    Value_2016,
    Value_2101 = 2101,
    Value_2102,
    Value_2103,
    Value_2104,
    Value_2105,
    Value_2106,
    Value_2107,
    Value_2108,
    Value_2109,
    Value_3000 = 3000,
    Value_3001,
    Value_3002,
    Value_3003,
    Value_3004,
    Value_3005,
    Value_3100 = 3100,
    Value_3101,
    Value_3102,
    Value_3103,
    Value_3104,
    Value_3105,
    Value_3106,
    Value_3107
}
