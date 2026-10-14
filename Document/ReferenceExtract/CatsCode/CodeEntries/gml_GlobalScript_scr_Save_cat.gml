function scr_Save_cat()
{
    var var_CatData = array_create(0);
    if (instance_exists(obj_Cat))
    {
        with (obj_Cat)
        {
            if (Shop_created == 0)
            {
                var var_CatArray = array_create(0);
                for (var var_i = 0; var_i < Passive_max; var_i += 1)
                {
                    var var_side = 
                    {
                        Cat_pos: Cat_pos,
                        Cat_type: Cat_type,
                        Cat_moved: Cat_moved,
                        Item0: Item_slot[0],
                        Item1: Item_slot[1],
                        Item2: Item_slot[2],
                        Item3: Item_slot[3],
                        pos_x: x,
                        pos_y: y,
                        Passive: Passive[var_i],
                        Cat_num: Cat_num[var_i],
                        Cat_chips: Cat_chips[var_i],
                        Cat_mult: Cat_mult[var_i],
                        Round_chips: Round_chips[var_i],
                        Round_mult: Round_mult[var_i],
                        Round_perm: Round_perm[var_i],
                        Cat_track: Cat_track[var_i]
                    };
                    array_push(var_CatArray, var_side);
                }
                array_push(var_CatData, var_CatArray);
            }
        }
    }
    var var_string = json_stringify(var_CatData);
    var _buffer = buffer_create(string_byte_length(var_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, var_string);
    buffer_save(_buffer, "Save_CatData.sav");
    buffer_delete(_buffer);
}
