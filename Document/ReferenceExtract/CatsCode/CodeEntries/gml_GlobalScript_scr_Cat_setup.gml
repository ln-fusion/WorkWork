function scr_Cat_setup(arg0)
{
    switch (arg0)
    {
        case UnknownEnum.Value_0:
            Passive[0] = UnknownEnum.Value_0;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Cat_cost = 5;
            Dice_effect[1] = [["<>", 1]];
            Dice_effect[6] = [["<>", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "SIC_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "SIC_passive", "");
            ini_close();
            subimg = 0;
            break;
        case UnknownEnum.Value_1:
            Passive[0] = UnknownEnum.Value_1;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[1] = [["$", 1]];
            Dice_effect[2] = [["$", 1]];
            Dice_effect[6] = [["M", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "GoldCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "GoldCat_passive", "");
            ini_close();
            subimg = 1;
            break;
        case UnknownEnum.Value_2:
            Passive[0] = UnknownEnum.Value_2;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[1] = [["R", 1]];
            Dice_effect[5] = [["^Add", 1]];
            Dice_effect[6] = [["^Add", 1]];
            Cat_chips[0] = 6;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Highroller_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Highroller_passive", "");
            ini_close();
            subimg = 2;
            break;
        case UnknownEnum.Value_3:
            Passive[0] = UnknownEnum.Value_3;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["M", 1]];
            Dice_effect[3] = [["$", 1]];
            Dice_effect[5] = [["M", 1]];
            Cat_mult[0] = 7;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Bookie_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Bookie_passive", "");
            ini_close();
            subimg = 3;
            break;
        case UnknownEnum.Value_4:
            Passive[0] = UnknownEnum.Value_4;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["P+", 1]];
            Dice_effect[2] = [["^Add", 1]];
            Cat_chips[0] = 11;
            Cat_mult[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Ace_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Ace_passive", "");
            ini_close();
            subimg = 4;
            break;
        case UnknownEnum.Value_5:
            Passive[0] = UnknownEnum.Value_5;
            Cat_cost = 4;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["<>", 1]];
            Dice_effect[6] = [["$", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Oldhand_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Oldhand_passive", "");
            ini_close();
            subimg = 5;
            break;
        case UnknownEnum.Value_6:
            Passive[0] = UnknownEnum.Value_6;
            Cat_cost = 6;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["Spade", 1]];
            Dice_effect[3] = [["Spade", 1]];
            Dice_effect[5] = [["Spade", 1]];
            Cat_mult[0] = 3;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "OddTodd_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "OddTodd_passive", "");
            ini_close();
            subimg = 6;
            break;
        case UnknownEnum.Value_7:
            Passive[0] = UnknownEnum.Value_7;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["Heart", 1]];
            Dice_effect[4] = [["Heart", 1]];
            Dice_effect[6] = [["Heart", 1]];
            Cat_mult[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "EvenSteven_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "EvenSteven_passive", "");
            ini_close();
            subimg = 7;
            break;
        case UnknownEnum.Value_8:
            Passive[0] = UnknownEnum.Value_8;
            Cat_cost = 4;
            Passive_skip[0] = 1;
            Slot_max = 4;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Item_slot[3] = -1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "SnowWhite_title", "");
            ini_close();
            subimg = 8;
            break;
        case UnknownEnum.Value_9:
            Passive[0] = UnknownEnum.Value_9;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_value[1] = 4;
            Dice_value[2] = 4;
            Dice_value[3] = 4;
            Dice_value[4] = 4;
            Dice_value[5] = 4;
            Dice_value[6] = 4;
            Dice_effect[2] = [["Heart", 1]];
            Dice_effect[4] = [["Heart", 1]];
            Dice_effect[6] = [["Heart", 1]];
            Cat_mult[0] = 4;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Quatro_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Quatro_passive", "");
            ini_close();
            subimg = 9;
            break;
        case UnknownEnum.Value_10:
            Passive[0] = UnknownEnum.Value_10;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_value[1] = 5;
            Dice_value[2] = 5;
            Dice_value[3] = 5;
            Dice_value[4] = 5;
            Dice_value[5] = 5;
            Dice_value[6] = 5;
            Dice_effect[1] = [["Spade", 1]];
            Dice_effect[3] = [["Spade", 1]];
            Dice_effect[5] = [["Spade", 1]];
            Cat_mult[0] = 5;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Cinco_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Cinco_passive", "");
            ini_close();
            subimg = 10;
            break;
        case UnknownEnum.Value_11:
            Passive[0] = UnknownEnum.Value_11;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["M", 1]];
            Dice_effect[5] = [["M", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Landlord_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Landlord_passive", "");
            ini_close();
            subimg = 11;
            break;
        case UnknownEnum.Value_12:
            Passive[0] = UnknownEnum.Value_12;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_value[1] = 3;
            Dice_value[2] = 3;
            Dice_value[3] = 3;
            Dice_value[4] = 3;
            Dice_value[5] = 3;
            Dice_value[6] = 3;
            Dice_effect[1] = [["R", 1]];
            Dice_effect[3] = [["^Add", 1]];
            Cat_chips[0] = 30;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Baller_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Baller_passive", "");
            ini_close();
            subimg = 12;
            break;
        case UnknownEnum.Value_42:
            Passive[0] = UnknownEnum.Value_42;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["SS", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "PrataCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "PrataCat_passive", "");
            ini_close();
            subimg = 13;
            break;
        case UnknownEnum.Value_14:
            Passive[0] = UnknownEnum.Value_14;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_value[1] = 1;
            Dice_value[2] = 2;
            Dice_value[3] = 3;
            Dice_value[4] = 1;
            Dice_value[5] = 2;
            Dice_value[6] = 3;
            Dice_effect[1] = [["^Add", 1]];
            Dice_effect[4] = [["^Add", 1]];
            Cat_chips[0] = 120;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "SmolKitten_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "SmolKitten_passive", "");
            ini_close();
            subimg = 14;
            break;
        case UnknownEnum.Value_15:
            Passive[0] = UnknownEnum.Value_15;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[5] = [["Boost", 1]];
            Dice_effect[6] = [["Boost", 1]];
            Cat_num[0] = 6;
            Cat_mult[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "LazyCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "LazyCat_passive", "");
            ini_close();
            subimg = 15;
            break;
        case UnknownEnum.Value_16:
            Passive[0] = UnknownEnum.Value_16;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["R", 1]];
            Dice_effect[4] = [["R", 1]];
            Cat_num[0] = 0;
            Cat_chips[0] = 100;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Chubby_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Chubby_passive", "");
            ini_close();
            subimg = 16;
            break;
        case UnknownEnum.Value_17:
            Passive[0] = UnknownEnum.Value_17;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[4] = [["R", 1]];
            Dice_effect[6] = [["R", 1]];
            Cat_chips[0] = 30;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Slim_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Slim_passive", "");
            ini_close();
            subimg = 17;
            break;
        case UnknownEnum.Value_18:
            Passive[0] = UnknownEnum.Value_18;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["M", 1]];
            Dice_effect[4] = [["M", 1]];
            Cat_num[0] = 0;
            Cat_mult[0] = 3;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Nix_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Nix_passive", "");
            ini_close();
            subimg = 18;
            break;
        case UnknownEnum.Value_19:
            Passive[0] = UnknownEnum.Value_19;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[1] = [["<>", 1]];
            Dice_effect[5] = [["M", 1]];
            Cat_num[0] = 1;
            Cat_chips[0] = 12;
            Round_perm[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "OnePunchCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "OnePunchCat_passive", "");
            ini_close();
            subimg = 19;
            break;
        case UnknownEnum.Value_20:
            Passive[0] = UnknownEnum.Value_20;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[6] = [["P+", 1]];
            Cat_chips[0] = 40;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Goalie_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Goalie_passive", "");
            ini_close();
            subimg = 20;
            break;
        case UnknownEnum.Value_21:
            Passive[0] = UnknownEnum.Value_21;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[6] = [["SS", 1]];
            Cat_chips[0] = 40;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Striker_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Striker_passive", "");
            ini_close();
            subimg = 21;
            break;
        case UnknownEnum.Value_22:
            Passive[0] = UnknownEnum.Value_22;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[4] = [["Boost", 1]];
            Dice_effect[5] = [["Boost", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "SunflowerCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "SunflowerCat_passive", "");
            ini_close();
            subimg = 22;
            break;
        case UnknownEnum.Value_23:
            Passive[0] = UnknownEnum.Value_23;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["<>", 1]];
            Dice_effect[5] = [["M", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Ragdoll_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Ragdoll_passive", "");
            ini_close();
            subimg = 23;
            break;
        case UnknownEnum.Value_24:
            Passive[0] = UnknownEnum.Value_24;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[6] = [["X2", 1]];
            Cat_num[0] = 2;
            Cat_mult[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "BoxCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "BoxCat_passive", "");
            ini_close();
            subimg = 24;
            break;
        case UnknownEnum.Value_25:
            Passive[0] = UnknownEnum.Value_25;
            Cat_cost = 4;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["Spade", 1]];
            Dice_effect[2] = [["Heart", 1]];
            Dice_effect[3] = [["Spade", 1]];
            Dice_effect[4] = [["Heart", 1]];
            Dice_effect[5] = [["Spade", 1]];
            Dice_effect[6] = [["Heart", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "FortuneTeller_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "FortuneTeller_passive", "");
            ini_close();
            subimg = 25;
            break;
        case UnknownEnum.Value_26:
            Passive[0] = UnknownEnum.Value_26;
            Cat_cost = 5;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["SS", 1]];
            Dice_effect[6] = [["R", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "WitchFamiliar_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "WitchFamiliar_passive", "");
            ini_close();
            subimg = 26;
            break;
        case UnknownEnum.Value_27:
            Passive[0] = UnknownEnum.Value_27;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[3] = [["Spade", 1], ["Heart", 1]];
            Dice_effect[6] = [["Spade", 1], ["Heart", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Sphynx_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Sphynx_passive", "");
            ini_close();
            subimg = 27;
            break;
        case UnknownEnum.Value_28:
            Passive[0] = UnknownEnum.Value_28;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_value[1] = 0;
            Dice_value[2] = 0;
            Dice_value[3] = 0;
            Dice_value[4] = 8;
            Dice_value[5] = 9;
            Dice_value[6] = 10;
            Dice_effect[4] = [["M", 1]];
            Dice_effect[5] = [["M", 1]];
            Dice_effect[6] = [["M", 1]];
            Cat_num[0] = 6;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Giant_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Giant_passive", "");
            ini_close();
            subimg = 28;
            break;
        case UnknownEnum.Value_29:
            Passive[0] = UnknownEnum.Value_29;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["<>", 1]];
            Dice_effect[4] = [["<>", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Jeweller_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Jeweller_passive", "");
            ini_close();
            subimg = 29;
            break;
        case UnknownEnum.Value_30:
            Passive[0] = UnknownEnum.Value_30;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["M", 1]];
            Dice_effect[4] = [["M", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Mathematician_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Mathematician_passive", "");
            ini_close();
            subimg = 30;
            break;
        case UnknownEnum.Value_31:
            Passive[0] = UnknownEnum.Value_31;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["$", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "CoinMaster_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "CoinMaster_passive", "");
            ini_close();
            subimg = 31;
            break;
        case UnknownEnum.Value_32:
            Passive[0] = UnknownEnum.Value_32;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[1] = [["Spade", 1]];
            Dice_effect[2] = [["Spade", 1]];
            Dice_effect[3] = [["Spade", 1]];
            Dice_effect[4] = [["Spade", 1]];
            Dice_effect[5] = [["Spade", 1]];
            Dice_effect[6] = [["Spade", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "KingSpade_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "KingSpade_passive", "");
            ini_close();
            subimg = 32;
            break;
        case UnknownEnum.Value_33:
            Passive[0] = UnknownEnum.Value_33;
            Cat_cost = 6;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[1] = [["Heart", 1]];
            Dice_effect[2] = [["Heart", 1]];
            Dice_effect[3] = [["Heart", 1]];
            Dice_effect[4] = [["Heart", 1]];
            Dice_effect[5] = [["Heart", 1]];
            Dice_effect[6] = [["Heart", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "QueenHeart_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "QueenHeart_passive", "");
            ini_close();
            subimg = 33;
            break;
        case UnknownEnum.Value_34:
            Passive[0] = UnknownEnum.Value_34;
            Cat_cost = 5;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["SS", 1]];
            Cat_mult[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Glutton_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Glutton_passive", "");
            ini_close();
            subimg = 100;
            break;
        case UnknownEnum.Value_35:
            Passive[0] = UnknownEnum.Value_35;
            Cat_cost = 8;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["X2", 1]];
            Cat_mult[0] = 1;
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Twins_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Twins_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 0;
            break;
        case UnknownEnum.Value_36:
            Passive[0] = UnknownEnum.Value_36;
            Cat_cost = 8;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["X2", 1]];
            Cat_mult[0] = 1;
            Cat_num[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Triplets_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Triplets_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 1;
            break;
        case UnknownEnum.Value_37:
            Passive[0] = UnknownEnum.Value_37;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[4] = [["X2", 1]];
            Cat_num[0] = 4;
            Cat_mult[0] = 4;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Quadruplets_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Quadruplets_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 2;
            break;
        case UnknownEnum.Value_38:
            Passive[0] = UnknownEnum.Value_38;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_value[1] = 1;
            Dice_value[2] = 1;
            Dice_value[3] = 1;
            Dice_value[4] = 1;
            Dice_value[5] = 1;
            Dice_value[6] = 1;
            Dice_effect[1] = [["X2", 1]];
            Dice_effect[4] = [["^R", 1]];
            Cat_mult[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "TheOne_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "TheOne_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 3;
            break;
        case UnknownEnum.Value_39:
            Passive[0] = UnknownEnum.Value_39;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[3] = [["<>", 1]];
            Dice_effect[6] = [["<>", 1]];
            Cat_mult[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Student_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Student_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 4;
            break;
        case UnknownEnum.Value_40:
            Passive[0] = UnknownEnum.Value_40;
            Cat_cost = 9;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_value[1] = 1;
            Dice_value[2] = 2;
            Dice_value[3] = 3;
            Dice_value[4] = 0;
            Dice_value[5] = 0;
            Dice_value[6] = 0;
            Dice_effect[1] = [["<>", 1]];
            Dice_effect[2] = [["<>", 1]];
            Dice_effect[3] = [["<>", 1]];
            Cat_num[0] = 3;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Professor_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Professor_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 5;
            break;
        case UnknownEnum.Value_41:
            Passive[0] = UnknownEnum.Value_41;
            Cat_cost = 9;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_value[1] = 6;
            Dice_value[2] = 6;
            Dice_value[3] = 6;
            Dice_value[4] = 6;
            Dice_value[5] = 6;
            Dice_value[6] = 6;
            Dice_effect[1] = [["M", 1]];
            Dice_effect[6] = [["M", 1]];
            Cat_mult[0] = 2;
            Round_perm[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Sixer_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Sixer_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 6;
            break;
        case UnknownEnum.Value_13:
            Passive[0] = UnknownEnum.Value_13;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["<>", 1]];
            Dice_effect[2] = [["<>", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "OldTraditional_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "OldTraditional_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 7;
            break;
        case UnknownEnum.Value_43:
            Passive[0] = UnknownEnum.Value_43;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["X2", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Auctioneer_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Auctioneer_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 8;
            break;
        case UnknownEnum.Value_44:
            Passive[0] = UnknownEnum.Value_44;
            Cat_cost = 9;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["R", 1]];
            Dice_effect[5] = [["R", 1]];
            Cat_num[0] = 1;
            Cat_mult[0] = 1;
            Round_perm[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "CubanCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "CubanCat_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 9;
            break;
        case UnknownEnum.Value_45:
            Passive[0] = UnknownEnum.Value_45;
            Cat_cost = 6;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[2] = [["M", 1]];
            Dice_effect[3] = [["M", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "TheCheat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "TheCheat_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 10;
            break;
        case UnknownEnum.Value_46:
            Passive[0] = UnknownEnum.Value_46;
            Cat_cost = 9;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[3] = [["P+", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Shieldmaiden_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Shieldmaiden_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 11;
            break;
        case UnknownEnum.Value_47:
            Passive[0] = UnknownEnum.Value_47;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["R", 1]];
            Dice_effect[2] = [["R", 1]];
            Dice_effect[5] = [["^Add", 1]];
            Cat_chips[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "JugglingCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "JugglingCat_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 12;
            break;
        case UnknownEnum.Value_48:
            Passive[0] = UnknownEnum.Value_48;
            Cat_cost = 8;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["R", 1]];
            Dice_effect[3] = [["R", 1]];
            Dice_effect[4] = [["^R", 1]];
            Cat_num[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "CatonBall_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "CatonBall_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 13;
            break;
        case UnknownEnum.Value_49:
            Passive[0] = UnknownEnum.Value_49;
            Cat_cost = 9;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["P+", 1]];
            Dice_effect[5] = [["P+", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "MiddleChild_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "MiddleChild_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 14;
            break;
        case UnknownEnum.Value_50:
            Passive[0] = UnknownEnum.Value_50;
            Cat_cost = 9;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["D", 1]];
            Dice_effect[4] = [["D", 1]];
            Cat_mult[0] = 1;
            Round_perm[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "NinjaCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "NinjaCat_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 15;
            break;
        case UnknownEnum.Value_51:
            Passive[0] = UnknownEnum.Value_51;
            Cat_cost = 8;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[4] = [["Boost", 1]];
            Dice_effect[5] = [["Boost", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "RocketCat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "RocketCat_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 16;
            break;
        case UnknownEnum.Value_52:
            Passive[0] = UnknownEnum.Value_52;
            Cat_cost = 9;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[2] = [["SS", 1]];
            Dice_effect[4] = [["SS", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "ParentChild_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "ParentChild_passive", "");
            ini_close();
            currentspr = spr_Cat_uncommon;
            subimg = 17;
            break;
        case UnknownEnum.Value_53:
            Passive[0] = UnknownEnum.Value_53;
            Cat_cost = 12;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["SS", 1]];
            Dice_effect[5] = [["SS", 1]];
            Cat_num[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Yinyang_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Yinyang_passive", "");
            ini_close();
            currentspr = spr_Cat_rare;
            subimg = 0;
            break;
        case UnknownEnum.Value_54:
            Passive[0] = UnknownEnum.Value_54;
            Cat_cost = 12;
            Slot_max = 3;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Item_slot[2] = -1;
            Dice_effect[1] = [["D", 1]];
            Dice_effect[5] = [["D", 1]];
            Cat_num[0] = 2;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Counterfeiter_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Counterfeiter_passive", "");
            ini_close();
            currentspr = spr_Cat_rare;
            subimg = 1;
            break;
        case UnknownEnum.Value_55:
            Passive[0] = UnknownEnum.Value_55;
            Cat_cost = 12;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_value[1] = 0;
            Dice_value[2] = 0;
            Dice_value[3] = 0;
            Dice_value[4] = 4;
            Dice_value[5] = 5;
            Dice_value[6] = 6;
            Dice_effect[3] = [["X2", 1]];
            Dice_effect[4] = [["X2", 1]];
            Cat_mult[0] = 1;
            Round_mult[0] = 0.5;
            Round_perm[0] = 1;
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Monopoly_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Monopoly_passive", "");
            ini_close();
            currentspr = spr_Cat_rare;
            subimg = 2;
            break;
        case UnknownEnum.Value_56:
            Passive[0] = UnknownEnum.Value_56;
            Cat_cost = 12;
            Slot_max = 2;
            Item_slot[0] = -1;
            Item_slot[1] = -1;
            Dice_effect[1] = [["X2", 1]];
            ini_open(global.lang_file);
            Text_Cat = ini_read_string("Cat_text", "Xcat_title", "");
            Text_Passive[0] = ini_read_string("Cat_text", "Xcat_passive", "");
            ini_close();
            currentspr = spr_Cat_rare;
            subimg = 3;
            break;
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
    Value_8,
    Value_9,
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
