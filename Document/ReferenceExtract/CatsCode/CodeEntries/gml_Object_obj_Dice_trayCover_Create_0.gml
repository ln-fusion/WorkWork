Sell_value = 0;
ini_open(global.lang_file);
Text = ini_read_string("Base_text", "Sell_title", "");
ini_close();
currentspr = spr_Dice_trayCover;
alpha = 0.92;
