Phase = 0;
counter = -10;
counter_max = 26;
Interest_earned = 0;
if (global.Interest_rate == 1)
{
    Interest_earned = global.Player_gold div 10;
    if (Interest_earned > 10)
    {
        Interest_earned = 10;
    }
}
Total_earned = 0;
ini_open(global.lang_file);
Text_payout = ini_read_string("Base_text", "Payout_title", "");
Text_victory = ini_read_string("Base_text", "Victory_title", "");
Text_roundreward = ini_read_string("Base_text", "Roundreward_title", "");
Text_remain = ini_read_string("Base_text", "RemainPlay_title", "");
Text_interest = ini_read_string("Base_text", "Interest_title", "");
Text_winnings = ini_read_string("Base_text", "Totalwinnings_title", "");
Text_demo1 = ini_read_string("Base_text", "Demo_body1", "");
ini_close();
Text = Text_payout;
currentspr = spr_Base_scoreboard;
if (global.Stage_progress >= 16)
{
    Phase = -1;
    Text = Text_victory;
}
