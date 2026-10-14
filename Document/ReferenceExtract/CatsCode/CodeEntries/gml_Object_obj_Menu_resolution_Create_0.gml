Selected = 0;
ini_open(global.lang_file);
Text = ini_read_string("Menu_text", "Menu_resolution", "");
ini_close();
Text_window = string(global.Screen_width) + "x" + string(global.Screen_height);
depth = layer_get_depth("UI") - 2;
currentspr = spr_Menu_resolution;
subimg = 0;
