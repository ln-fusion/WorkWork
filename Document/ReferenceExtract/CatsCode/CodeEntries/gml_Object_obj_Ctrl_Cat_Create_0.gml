x = 90;
y = 188;
Score_start = 0;
Score_order = 0;
for (var var_i = 0; var_i < 6; var_i += 1)
{
    with (instance_create_layer(x + (var_i * 84), y, "Base", obj_Position))
    {
        Position = var_i;
    }
    Cat_pos[var_i] = -4;
}
Gamestart = 0;
Midgame = 0;
Start_roll = 0;
Roll_counter = 0;
Roll_counterMax = 16;
Wait_counter = 0;
Wait_counterMax = 60;
ini_open(global.lang_file);
Text_current = ini_read_string("Base_text", "Current_title", "");
Text_reward = ini_read_string("Base_text", "Reward_title", "");
Text_round = ini_read_string("Base_text", "Round_title", "");
Text_atleast = ini_read_string("Base_text", "Atleast_title", "");
Text_nextround = ini_read_string("Base_text", "Nextround_title", "");
Text_BonusPair = ini_read_string("Mechanics_text", "Pair_title", "");
Text_BonusTriple = ini_read_string("Mechanics_text", "Triple_title", "");
Text_BonusSame4 = ini_read_string("Mechanics_text", "4kind_title", "");
Text_BonusSame5 = ini_read_string("Mechanics_text", "5kind_title", "");
Text_BonusSame6 = ini_read_string("Mechanics_text", "6kind_title", "");
Text_BonusAlldif = ini_read_string("Mechanics_text", "Alldif_title", "");
Text_BonusBlackjack = ini_read_string("Mechanics_text", "Blackjack_title", "");
Text_BonusBust = ini_read_string("Mechanics_text", "Bust_title", "");
Text_BonusLowroll = ini_read_string("Mechanics_text", "Lowroll_title", "");
Text_BonusHighroll = ini_read_string("Mechanics_text", "Highroll_title", "");
Text_BonusStraight = ini_read_string("Mechanics_text", "Straight_title", "");
Text_BonusEmpty = ini_read_string("Mechanics_text", "Empty_title", "");
Text_Boonbane = ini_read_string("Base_text", "Boonbane_title", "");
ini_close();
Text_preview = Text_atleast;
fontpoints_freeze = 0;
fontpoints_freeze_counter = 0;
fontpoints_scale = 1;
fontmult_freeze = 0;
fontmult_freeze_counter = 0;
fontmult_scale = 1;
scoreboard_freeze = 0;
scoreboard_freeze_counter = 0;
scoreboard_sprite = spr_UI_Scoreboard;
scoreboard_subimg = 0;
scoreboard_target = 0;
scoreboard_scale = 1;
centerboard_subimg = 0;
infobar_win = 0;
win_subimg = 0;
infobar_display = 0;
infobar_counter = 0;
infobar_counterMax = 80;
infobar_text = "";
if (file_exists("Save_RunData.sav"))
{
    var _buffer = buffer_load("Save_RunData.sav");
    var var_string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    var var_SaveData = json_parse(var_string);
    if (struct_get(var_SaveData, "Ongoing") != undefined && var_SaveData.Ongoing == 1)
    {
        Gamestart = 1;
        global.Phase = var_SaveData.Phase;
        global.Difficulty_lvl = var_SaveData.Difficulty_lvl;
        global.Shop_rerollcost = var_SaveData.Shop_rerollcost;
        global.Player_gold = var_SaveData.Player_gold;
        global.Player_score = var_SaveData.Player_score;
        global.Player_reroll = var_SaveData.Player_reroll;
        global.Stage_progress = var_SaveData.Stage_progress;
        global.Stage_earnings = var_SaveData.Stage_earnings;
        global.Start_points = var_SaveData.Start_points;
        global.Start_mult = var_SaveData.Start_mult;
        global.Round_score = var_SaveData.Round_score;
        global.Round_reroll = var_SaveData.Round_reroll;
        global.Attempt_score = var_SaveData.Attempt_score;
        global.Track_reroll = var_SaveData.Track_reroll;
        global.Chips = var_SaveData.Chips;
        global.Chips_next = var_SaveData.Chips_next;
        global.Mult = var_SaveData.Mult;
        global.Mult_next = var_SaveData.Mult_next;
        global.Dice_value = var_SaveData.Dice_value;
        global.DicePrevious_value = var_SaveData.DicePrevious_value;
        global.Dice_position = var_SaveData.Dice_position;
        global.Score_current = var_SaveData.Score_current;
        global.Score_total = var_SaveData.Score_total;
        global.Score_needed = var_SaveData.Score_needed;
        if (struct_get(var_SaveData, "Shoplist_ticket") != undefined)
        {
            with (global_Level)
            {
                ds_list_read(Shoplist_ticket, var_SaveData.Shoplist_ticket);
            }
        }
        if (struct_get(var_SaveData, "List_bonus") != undefined)
        {
            with (global_Level)
            {
                ds_list_read(List_bonus, var_SaveData.List_bonus);
                if (!ds_list_empty(List_bonus))
                {
                    scr_Bonus_initialize();
                }
            }
        }
        if (struct_get(var_SaveData, "List_boon") != undefined)
        {
            with (global_Level)
            {
                ds_list_read(List_boon, var_SaveData.List_boon);
                Boon[0] = var_SaveData.Boon0;
                Boon[1] = var_SaveData.Boon1;
                Boon[2] = var_SaveData.Boon2;
                ds_list_read(List_bane, var_SaveData.List_bane);
                Bane[0] = var_SaveData.Bane0;
                Bane[1] = var_SaveData.Bane1;
                Bane[2] = var_SaveData.Bane2;
                if (!ds_list_empty(List_boon))
                {
                    for (var var_i = 0; var_i < ds_list_size(List_boon); var_i += 1)
                    {
                        var var_boon = ds_list_find_value(List_boon, var_i);
                        scr_Boonbane_setup("Boon", var_boon, 1);
                    }
                }
                if (!ds_list_empty(List_bane))
                {
                    for (var var_i = 0; var_i < ds_list_size(List_bane); var_i += 1)
                    {
                        var var_bane = ds_list_find_value(List_bane, var_i);
                        scr_Boonbane_setup("Bane", var_bane, 1);
                    }
                }
            }
            if (global.Phase == "BoonBane")
            {
                global.Phase = "BoonBane_load";
            }
        }
    }
    else
    {
        exit;
    }
    if (file_exists("Save_ShopData.sav"))
    {
        _buffer = buffer_load("Save_ShopData.sav");
        var_string = buffer_read(_buffer, buffer_string);
        buffer_delete(_buffer);
        var var_ShopData = json_parse(var_string);
        with (global_Level)
        {
            if (struct_get(var_ShopData, "Ticket_refresh") != undefined)
            {
                Ticket_refresh = var_ShopData.Ticket_refresh;
            }
        }
    }
    if (file_exists("Save_CatData.sav"))
    {
        var _bufferInven = buffer_load("Save_CatData.sav");
        var var_stringCat = buffer_read(_bufferInven, buffer_string);
        buffer_delete(_bufferInven);
        var var_CatData = json_parse(var_stringCat);
        while (array_length(var_CatData) > 0)
        {
            var var_CatArray = array_shift(var_CatData);
            with (instance_create_layer(x, y, "Cat", obj_Cat))
            {
                for (var var_i = 0; var_i < Passive_max; var_i += 1)
                {
                    var var_side = array_shift(var_CatArray);
                    if (var_i == 0)
                    {
                        Cat_pos = var_side.Cat_pos;
                        Cat_type = var_side.Cat_type;
                        Cat_moved = var_side.Cat_moved;
                        x = var_side.pos_x;
                        y = var_side.pos_y;
                        scr_Cat_setup(Cat_type);
                        Item_slot[0] = var_side.Item0;
                        Item_slot[1] = var_side.Item1;
                        Item_slot[2] = var_side.Item2;
                        Item_slot[3] = var_side.Item3;
                        for (var var_j = 0; var_j < Slot_max; var_j += 1)
                        {
                            if (Item_slot[var_j] >= 0)
                            {
                                var var_x = 0;
                                var var_y = 0;
                                switch (var_j)
                                {
                                    case 0:
                                        var_x = x - 27;
                                        var_y = y - 74;
                                        break;
                                    case 1:
                                        var_x = x + 27;
                                        var_y = y - 74;
                                        break;
                                    case 2:
                                        var_x = x - 27;
                                        var_y = y - 10;
                                        break;
                                    case 3:
                                        var_x = x + 27;
                                        var_y = y - 10;
                                        break;
                                }
                                Passive[var_j + 1] = Item_slot[var_j];
                                scr_Item_setup(Passive[var_j + 1], var_j + 1);
                                with (instance_create_layer(var_x, var_y, "Item", obj_Item))
                                {
                                    Master = other.id;
                                    relative_x = x - other.x;
                                    relative_y = y - other.y;
                                    Item_type = other.Item_slot[var_j];
                                    Item_passivenum = var_j + 1;
                                    Item_pos = var_j;
                                    scr_Item_setup(Item_type, -4);
                                }
                            }
                        }
                    }
                    Passive[var_i] = var_side.Passive;
                    Cat_num[var_i] = var_side.Cat_num;
                    Cat_chips[var_i] = var_side.Cat_chips;
                    Cat_mult[var_i] = var_side.Cat_mult;
                    Round_chips[var_i] = var_side.Round_chips;
                    Round_mult[var_i] = var_side.Round_mult;
                    Round_perm[var_i] = var_side.Round_perm;
                    Cat_track[var_i] = var_side.Cat_track;
                }
                with (instance_place(x, y, obj_Position))
                {
                    Occupied = 1;
                    subimg = Position + 1;
                }
            }
        }
    }
    if (global.Phase == "Play")
    {
        Midgame = 1;
        if (file_exists("Save_DiceData.sav"))
        {
            var _bufferDice = buffer_load("Save_DiceData.sav");
            var var_stringDice = buffer_read(_bufferDice, buffer_string);
            buffer_delete(_bufferDice);
            var var_DiceData = json_parse(var_stringDice);
            while (array_length(var_DiceData) > 0)
            {
                var var_DiceSingle = array_shift(var_DiceData);
                with (instance_create_layer(x, y, "Dice", obj_Dice))
                {
                    for (var var_i = 1; var_i < 7; var_i += 1)
                    {
                        var var_side = array_shift(var_DiceSingle);
                        if (var_i == 1)
                        {
                            Dice_tray = var_side.Dice_tray;
                            Dice_face = var_side.Dice_face;
                            Face_next = var_side.Face_next;
                            x = var_side.pos_x;
                            y = var_side.pos_y;
                        }
                        Master = var_side.Master;
                        Dice_value[var_i] = var_side.Dice_value;
                        Dice_effect[var_i] = var_side.Dice_effect;
                    }
                    subimg = Dice_value[Dice_face];
                    Draw_effect = 1;
                    Silent = 0;
                    Rolling = 0;
                    if (Master != -4)
                    {
                        subimg_outline = Master + 1;
                        var var_cat = -4;
                        with (obj_Cat)
                        {
                            if (Cat_pos == other.Master)
                            {
                                var_cat = id;
                            }
                        }
                        Master = var_cat;
                    }
                    if (Dice_tray >= 0)
                    {
                        with (obj_Dice_tray)
                        {
                            Dice_total += 1;
                        }
                    }
                }
            }
            with (obj_Position)
            {
                if (place_meeting(x, y, obj_Dice))
                {
                    Dice_ID = instance_place(x, y, obj_Dice);
                }
            }
            scr_Dice_combo_check(0);
        }
    }
    else if (global.Phase == "Shop")
    {
        if (file_exists("Save_ShopData.sav"))
        {
            _buffer = buffer_load("Save_ShopData.sav");
            var_string = buffer_read(_buffer, buffer_string);
            buffer_delete(_buffer);
            var var_ShopData = json_parse(var_string);
            with (global_Level)
            {
                Shop_cat[0] = var_ShopData.Shop_cat0;
                Shop_cat[1] = var_ShopData.Shop_cat1;
                Shop_item[0] = var_ShopData.Shop_item0;
                Shop_item[1] = var_ShopData.Shop_item1;
                Shop_item[2] = var_ShopData.Shop_item2;
                Reroll_cost = var_ShopData.Reroll_cost;
                if (struct_get(var_ShopData, "Ticket_refresh") != undefined)
                {
                    Ticket_refresh = var_ShopData.Ticket_refresh;
                }
            }
            global.Phase = "Shop_load";
            global.Round_score = "";
        }
        scr_Stage_score(1);
        with (obj_Ctrl_Cat)
        {
            Text_preview = Text_nextround;
        }
    }
}
else
{
    with (global_Level)
    {
        ds_list_add(List_bonus, ["Pair", 20, 2, 1]);
        ds_list_add(List_bonus, ["Triple", 30, 4, 1]);
        ds_list_add(List_bonus, ["4Kind", 40, 7, 1]);
        ds_list_add(List_bonus, ["5Kind", 50, 10, 1]);
        ds_list_add(List_bonus, ["6Kind", 60, 14, 1]);
        ds_list_add(List_bonus, ["Distinct", 60, 12, 1]);
    }
    scr_Bonus_initialize();
    with (global_Level)
    {
        for (var var_i = 0; var_i < UnknownEnum.Value_3; var_i += 1)
        {
            ds_list_add(Shoplist_ticket, var_i);
        }
        for (var var_j = 4; var_j < UnknownEnum.Value_6; var_j += 1)
        {
            ds_list_add(Shoplist_ticket, var_j);
        }
        ds_list_add(Shoplist_ticket, 100, 101, 102, 103, 104, 106, 107, 108);
        ds_list_shuffle(Shoplist_ticket);
        for (var var_k = 0; var_k < UnknownEnum.Value_3; var_k += 1)
        {
            var var_pos = ds_list_find_index(Shoplist_ticket, var_k);
            if (var_pos < floor(ds_list_size(Shoplist_ticket) / 2))
            {
                var var_random = irandom_range(floor(ds_list_size(Shoplist_ticket) / 2) + 1, ds_list_size(Shoplist_ticket) - 1);
                ds_list_insert(Shoplist_ticket, var_random, var_k);
            }
            else
            {
                var var_random = irandom_range(0, floor(ds_list_size(Shoplist_ticket) / 2));
                ds_list_insert(Shoplist_ticket, var_random, var_k);
            }
        }
    }
}

enum UnknownEnum
{
    Value_3 = 3,
    Value_6 = 6
}
