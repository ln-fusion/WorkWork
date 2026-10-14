if (room == rm_Titlescreen)
{
    Interactable = 0;
}
else
{
    Interactable = 1;
}
Proceed = 0;
wait_counter = 0;
ini_open(global.lang_file);
Text = ini_read_string("Menu_text", "Menu_titlescreen", "");
ini_close();
depth = layer_get_depth("UI") - 2;
currentspr = spr_Menu_titlescreen;
subimg = 0;
shift_y = 0;
