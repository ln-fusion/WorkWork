ini_open(global.lang_file);
Text = ini_read_string("Menu_text", "Menu_borderless", "");
ini_close();
depth = layer_get_depth("UI") - 2;
currentspr = spr_Menu_fullscreen;
subimg = 0;
if (global.Fullscreen == 0.5)
{
    subimg = 2;
}
