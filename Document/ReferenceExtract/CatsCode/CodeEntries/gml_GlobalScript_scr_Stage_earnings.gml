function scr_Stage_earnings()
{
    var var_interest = 0;
    if (global.Interest_rate == 1)
    {
        var_interest = global.Player_gold div 10;
    }
    global.Player_gold += (global.Stage_earnings + global.Extra_earnings);
    global.Player_gold += global.Round_score;
    global.Player_gold += var_interest;
}
