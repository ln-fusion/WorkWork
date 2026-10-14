function scr_Save_dice()
{
    var var_DiceData = array_create(0);
    if (instance_exists(obj_Dice))
    {
        with (obj_Dice)
        {
            var var_Master = -4;
            if (Master != -4)
            {
                var_Master = Master.Cat_pos;
            }
            var var_DiceSingle = array_create(0);
            for (var var_i = 1; var_i < 7; var_i += 1)
            {
                var var_Effect = 
                {
                    Dice_tray: Dice_tray,
                    Dice_face: Dice_face,
                    Face_next: Face_next,
                    pos_x: x,
                    pos_y: y,
                    Master: var_Master,
                    Dice_value: Dice_value[var_i],
                    Dice_effect: Dice_effect[var_i]
                };
                array_push(var_DiceSingle, var_Effect);
            }
            array_push(var_DiceData, var_DiceSingle);
        }
    }
    var var_string = json_stringify(var_DiceData);
    var _buffer = buffer_create(string_byte_length(var_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, var_string);
    buffer_save(_buffer, "Save_DiceData.sav");
    buffer_delete(_buffer);
}
