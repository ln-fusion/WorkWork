if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    switch (global.Phase)
    {
        case "Play":
            if (Selected == 0)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && !place_meeting(x, y, obj_Dice))
                {
                    if (global.Rmouse_pressed)
                    {
                        var var_move_x = 0;
                        for (var var_i = 0; var_i < 6; var_i += 1)
                        {
                            with (instance_create_layer((x - 20) + (var_i * 45), y - 124, "Dice", obj_Dice_face))
                            {
                                Master = other.id;
                                Dice_face = var_i + 1;
                                Dice_value = other.Dice_value[var_i + 1];
                                var var_len = array_length(other.Dice_effect[var_i + 1]);
                                array_copy(Dice_effect, 0, other.Dice_effect[var_i + 1], 0, var_len);
                                subimg = Dice_value;
                                subimg_outline = other.Cat_pos + 1;
                                if (x > (global.Camera_width - 16))
                                {
                                    var_move_x += 45;
                                }
                            }
                        }
                        with (obj_Dice_face)
                        {
                            if (Master == other.id)
                            {
                                x -= var_move_x;
                            }
                        }
                        with (instance_create_layer(0, 0, "Dice", obj_greyscreen))
                        {
                            Master = other.id;
                        }
                        depth = layer_get_depth("Dice") - 2;
                    }
                }
            }
            break;
        case "Shop":
            if (Selected == 0)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && !place_meeting(x, y, obj_Dice))
                {
                    if (global.Rmouse_pressed)
                    {
                        if (instance_exists(obj_Dice_face))
                        {
                            with (obj_Dice_face)
                            {
                                if (Shop_cat == 1)
                                {
                                    with (Master)
                                    {
                                        if (object_index == obj_Dice)
                                        {
                                            depth = layer_get_depth("Dice");
                                        }
                                        else if (object_index == obj_Cat)
                                        {
                                            depth = layer_get_depth("Cat");
                                        }
                                    }
                                    instance_destroy();
                                }
                            }
                            with (obj_greyscreen)
                            {
                                instance_destroy();
                            }
                        }
                        var var_move_x = 0;
                        var var_y = 0;
                        if (Shop_created == 0)
                        {
                            var_y = -124;
                        }
                        else
                        {
                            var_y = 13;
                        }
                        for (var var_i = 0; var_i < 6; var_i += 1)
                        {
                            with (instance_create_layer((x - 20) + (var_i * 45), y + var_y, "Dice", obj_Dice_face))
                            {
                                Master = other.id;
                                Dice_face = var_i + 1;
                                Dice_value = other.Dice_value[var_i + 1];
                                var var_len = array_length(other.Dice_effect[var_i + 1]);
                                array_copy(Dice_effect, 0, other.Dice_effect[var_i + 1], 0, var_len);
                                subimg = Dice_value;
                                if (other.Shop_created == 0)
                                {
                                    subimg_outline = other.Cat_pos + 1;
                                }
                                if (x > (global.Camera_width - 16))
                                {
                                    var_move_x += 45;
                                }
                            }
                        }
                        with (obj_Dice_face)
                        {
                            if (Master == other.id)
                            {
                                x -= var_move_x;
                            }
                        }
                        with (instance_create_layer(0, 0, "Dice", obj_greyscreen))
                        {
                            Master = other.id;
                        }
                        depth = layer_get_depth("Dice") - 2;
                    }
                }
            }
            break;
        case "BoonBane":
            if (Selected == 0)
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && !place_meeting(x, y, obj_Dice))
                {
                    if (global.Rmouse_pressed)
                    {
                        var var_move_x = 0;
                        for (var var_i = 0; var_i < 6; var_i += 1)
                        {
                            with (instance_create_layer((x - 20) + (var_i * 45), y - 124, "Dice", obj_Dice_face))
                            {
                                Master = other.id;
                                Dice_face = var_i + 1;
                                Dice_value = other.Dice_value[var_i + 1];
                                var var_len = array_length(other.Dice_effect[var_i + 1]);
                                array_copy(Dice_effect, 0, other.Dice_effect[var_i + 1], 0, var_len);
                                subimg = Dice_value;
                                subimg_outline = other.Cat_pos + 1;
                                if (x > (global.Camera_width - 16))
                                {
                                    var_move_x += 45;
                                }
                            }
                        }
                        with (obj_Dice_face)
                        {
                            if (Master == other.id)
                            {
                                x -= var_move_x;
                            }
                        }
                        with (instance_create_layer(0, 0, "Dice", obj_greyscreen))
                        {
                            Master = other.id;
                        }
                        depth = layer_get_depth("Dice") - 2;
                    }
                }
            }
            break;
    }
}
else if (global.Game_Pause == 1)
{
}
