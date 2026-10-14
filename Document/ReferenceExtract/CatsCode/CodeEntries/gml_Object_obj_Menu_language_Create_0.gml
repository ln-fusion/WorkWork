Selected = 0;
ini_open(global.lang_file);
Text = ini_read_string("Menu_text", "Menu_language", "");
Text_window = ini_read_string("Menu_text", "Language_English", "");
switch (global.lang_file)
{
    case "lang_English.txt":
        Text_window = ini_read_string("Menu_text", "Language_English", "");
        break;
    case "lang_ChineseS.txt":
        Text_window = ini_read_string("Menu_text", "Language_ChineseS", "");
        break;
    case "lang_ChineseT.txt":
        Text_window = ini_read_string("Menu_text", "Language_ChineseT", "");
        break;
}
ini_close();
depth = layer_get_depth("UI") - 2;
currentspr = spr_Menu_resolution;
subimg = 0;
