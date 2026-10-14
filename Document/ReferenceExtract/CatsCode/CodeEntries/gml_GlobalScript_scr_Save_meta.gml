function scr_Save_meta()
{
    var var_MetaData = 
    {
        Screenshot: global_Control.Screenshot,
        Tutorial: global.Tut_Progress
    };
    var var_string = json_stringify(var_MetaData);
    var _buffer = buffer_create(string_byte_length(var_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, var_string);
    buffer_save(_buffer, "Save_MetaData.sav");
    buffer_delete(_buffer);
}
