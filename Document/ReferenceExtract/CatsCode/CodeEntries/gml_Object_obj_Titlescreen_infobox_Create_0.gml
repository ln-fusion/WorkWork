ini_open(global.lang_file);
Text = ini_read_string("Base_text", "Infobox_body", "");
ini_close();
currentspr = spr_Titlescreen_infobox;
