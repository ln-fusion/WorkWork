function scr_Save_run()
{
    var var_RunData = 
    {
        Ongoing: 1,
        Phase: global.Phase,
        Difficulty_lvl: global.Difficulty_lvl,
        Shop_rerollcost: global.Shop_rerollcost,
        Player_gold: global.Player_gold,
        Player_score: global.Player_score,
        Player_reroll: global.Player_reroll,
        Stage_progress: global.Stage_progress,
        Stage_earnings: global.Stage_earnings,
        Start_points: global.Start_points,
        Start_mult: global.Start_mult,
        Round_score: global.Round_score,
        Round_reroll: global.Round_reroll,
        Attempt_score: global.Attempt_score,
        Track_reroll: global.Track_reroll,
        Chips: global.Chips,
        Chips_next: global.Chips_next,
        Mult: global.Mult,
        Mult_next: global.Mult_next,
        Dice_value: global.Dice_value,
        DicePrevious_value: global.DicePrevious_value,
        Dice_position: global.Dice_position,
        Score_current: global.Score_current,
        Score_total: global.Score_total,
        Score_needed: global.Score_needed,
        Shoplist_ticket: ds_list_write(global_Level.Shoplist_ticket),
        List_bonus: ds_list_write(global_Level.List_bonus),
        List_boon: ds_list_write(global_Level.List_boon),
        Boon0: global_Level.Boon[0],
        Boon1: global_Level.Boon[1],
        Boon2: global_Level.Boon[2],
        List_bane: ds_list_write(global_Level.List_bane),
        Bane0: global_Level.Bane[0],
        Bane1: global_Level.Bane[1],
        Bane2: global_Level.Bane[2]
    };
    var var_string = json_stringify(var_RunData);
    var _buffer = buffer_create(string_byte_length(var_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, var_string);
    buffer_save(_buffer, "Save_RunData.sav");
    buffer_delete(_buffer);
}
