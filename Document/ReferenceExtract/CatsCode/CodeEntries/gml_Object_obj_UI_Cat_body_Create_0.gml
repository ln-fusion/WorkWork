Master = -4;
if (x < camera_get_view_x(global.Camera))
{
    x = camera_get_view_x(global.Camera) + 2;
}
Cat_num = -1;
Cat_chips = -1;
Cat_mult = -1;
Round_chips = 0;
Round_mult = 0;
Text_body = "";
ini_open(global.lang_file);
Text_Points = ini_read_string("Mechanics_text", "Points_text", "");
Text_Mult = ini_read_string("Mechanics_text", "Mult_text", "");
ini_close();
currentspr = spr_UI_Cat_body;
subimg = 0;
