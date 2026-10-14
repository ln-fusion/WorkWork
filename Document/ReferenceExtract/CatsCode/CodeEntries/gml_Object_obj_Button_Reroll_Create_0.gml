x = room_width - 36;
y = 266;
ini_open(global.lang_file);
Text = ini_read_string("Base_text", "Reroll_title", "");
ini_close();
currentspr = spr_Button_Reroll;
subimg = 2;
shift_y = 0;
