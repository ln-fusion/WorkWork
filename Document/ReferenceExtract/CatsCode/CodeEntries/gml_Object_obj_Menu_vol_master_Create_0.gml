Width = sprite_get_width(spr_Menu_sound_bar);
with (instance_create_layer(x, y, "UI", obj_Menu_vol_ctrl))
{
    Master = other.id;
    x += (other.Width * global.Volume_Master);
}
ini_open(global.lang_file);
Text = ini_read_string("Menu_text", "Menu_volmaster", "");
ini_close();
depth = layer_get_depth("UI") - 2;
currentspr = spr_Menu_sound_bar;
subimg = 0;
