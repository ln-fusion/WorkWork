if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (!instance_exists(Master))
    {
        instance_destroy();
        exit;
    }
    if (Master.Selected != 0)
    {
        instance_destroy();
        exit;
    }
    if (!position_meeting(obj_Cursor.x, obj_Cursor.y, Master))
    {
        instance_destroy();
        exit;
    }
    if (Setup == 0)
    {
        switch (currentspr)
        {
            case spr_UI_Dice_body:
                Box_height = 14;
                break;
            case spr_UI_Dice_body2:
                Box_height = 25;
                break;
            case spr_UI_Dice_body3:
                Box_height = 37;
                break;
        }
        Setup = 1;
    }
    if (Setup == 1)
    {
        if ((y + Box_height) > (global.Camera_height - global.Camera_offset_y))
        {
            if (Creation_num == 0)
            {
                y = Master.y - 22 - Box_height;
                var var_y = y;
                for (var var_i = 1; var_i < instance_number(obj_UI_Dice_body); var_i += 1)
                {
                    with (obj_UI_Dice_body)
                    {
                        if (Creation_num == var_i)
                        {
                            switch (currentspr)
                            {
                                case spr_UI_Dice_body:
                                    Box_height = 14;
                                    break;
                                case spr_UI_Dice_body2:
                                    Box_height = 25;
                                    break;
                                case spr_UI_Dice_body3:
                                    Box_height = 37;
                                    break;
                            }
                            y = var_y - Box_height - 2;
                            var_y = y;
                        }
                    }
                }
            }
            else
            {
                var var_y = 0;
                with (obj_UI_Dice_body)
                {
                    if (Creation_num == 0)
                    {
                        var_y = y;
                    }
                }
                var var_move_y = y - var_y;
                y = var_y;
                x += (Box_width + 2);
                with (obj_UI_Dice_body)
                {
                    if (Creation_num > other.Creation_num)
                    {
                        x += (Box_width + 2);
                        y -= var_move_y;
                    }
                }
            }
        }
        if ((x + Box_width) > (global.Camera_width - global.Camera_offset_x))
        {
            var var_move_x = abs((x + Box_width) - (global.Camera_width - global.Camera_offset_x)) + 2;
            with (obj_UI_Dice_body)
            {
                x -= var_move_x;
            }
        }
        Setup = 2;
    }
}
else if (global.Game_Pause == 1)
{
}
