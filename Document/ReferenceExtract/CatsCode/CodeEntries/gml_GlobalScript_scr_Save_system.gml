function scr_Save_system()
{
    var var_SystemData = 
    {
        Fullscreen: global.Fullscreen,
        Screen_width: global.Screen_width,
        Screen_height: global.Screen_height,
        Volume_Master: global.Volume_Master,
        Volume_SFX: global.Volume_SFX,
        Volume_Music: global.Volume_Music,
        lang_file: global.lang_file
    };
    var var_string = json_stringify(var_SystemData);
    var _buffer = buffer_create(string_byte_length(var_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, var_string);
    buffer_save(_buffer, "Save_SystemData.sav");
    buffer_delete(_buffer);
}
