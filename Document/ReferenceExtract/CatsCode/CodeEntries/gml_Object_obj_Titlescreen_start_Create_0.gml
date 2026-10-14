Ready = 0;
Proceed = 0;
wait_counter = 0;
currentspr = spr_Titlescreen_start_ready;
subimg = 0;
shift_y = 0;
alpha = 0;
ini_open(global.lang_file);
Text_play = ini_read_string("Base_text", "Play_title", "");
Text_continue = ini_read_string("Base_text", "Continue_title", "");
ini_close();
Text = Text_play;
if (file_exists("Save_RunData.sav"))
{
    var _buffer = buffer_load("Save_RunData.sav");
    var var_string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    var var_SaveData = json_parse(var_string);
    if (struct_get(var_SaveData, "Ongoing") != undefined && var_SaveData.Ongoing == 1)
    {
        Text = Text_continue;
        instance_create_layer(x, y, "UI", obj_Titlescreen_newgame);
        y += -36;
        currentspr = spr_Titlescreen_continue_ready;
        sprite_index = spr_Titlescreen_continue;
        mask_index = spr_Titlescreen_continue;
    }
}
