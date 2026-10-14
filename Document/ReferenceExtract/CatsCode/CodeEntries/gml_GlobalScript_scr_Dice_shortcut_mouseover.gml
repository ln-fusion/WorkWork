function scr_Dice_shortcut_mouseover()
{
    if (global.One_pressed || global.Two_pressed || global.Three_pressed || global.Four_pressed || global.Five_pressed || global.Six_pressed)
    {
        var var_place = 0;
        if (global.One_pressed)
        {
            var_place = 1;
        }
        else if (global.Two_pressed)
        {
            var_place = 2;
        }
        else if (global.Three_pressed)
        {
            var_place = 3;
        }
        else if (global.Four_pressed)
        {
            var_place = 4;
        }
        else if (global.Five_pressed)
        {
            var_place = 5;
        }
        else if (global.Six_pressed)
        {
            var_place = 6;
        }
        var var_position = -4;
        var var_dice = -4;
        with (obj_Position)
        {
            if (Position == (var_place - 1))
            {
                var_position = id;
                if (Dice_ID != -4)
                {
                    var_dice = Dice_ID;
                }
            }
        }
        audio_play_sound(sfx_Dice_slotin, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
        with (obj_Cursor)
        {
            Holding = 0;
        }
        Selected = 0;
        x = var_position.x;
        y = var_position.y + 20;
        xscale = 1.1;
        yscale = 1.1;
        if (Dice_tray > 0)
        {
            with (obj_Dice_tray)
            {
                Dice_total -= 1;
            }
            with (obj_Dice)
            {
                if (Dice_tray > other.Dice_tray)
                {
                    Dice_tray -= 1;
                    Rolling = 1.1;
                    Wait_counter = Wait_counterMax;
                    Silent = 1;
                }
            }
        }
        else
        {
            with (obj_Position)
            {
                if (Dice_ID == other.id)
                {
                    Dice_ID = -4;
                }
            }
        }
        with (var_position)
        {
            Dice_ID = other.id;
        }
        Dice_tray = -1;
        if (var_dice != -4)
        {
            with (var_dice)
            {
                Rolling = 1.1;
                Wait_counter = Wait_counterMax;
                if (Dice_tray <= -1)
                {
                    with (obj_Dice_tray)
                    {
                        Dice_total += 1;
                    }
                    Dice_tray = obj_Dice_tray.Dice_total;
                }
            }
            with (obj_Position)
            {
                if (Dice_ID == var_dice)
                {
                    Dice_ID = -4;
                }
            }
        }
        scr_Dice_combo_check(0);
        exit;
    }
}
