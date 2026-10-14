if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (Dice_create == 1)
    {
        with (instance_create_layer(x, y, "Dice", obj_Dice))
        {
            scr_Dice_setup(-4);
            Dice_face = choose(1, 2, 3, 4, 5, 6);
            with (obj_Dice_tray)
            {
                Dice_total += 1;
            }
            Dice_tray = obj_Dice_tray.Dice_total;
            Roll_dir = irandom_range(0, 359);
            spd = random_range(spdMin, spdMax);
            vx = cos(degtorad(Roll_dir)) * spd;
            vy = sin(degtorad(Roll_dir)) * -spd;
            rotate = irandom_range(0, 359);
            subimg = Dice_value[irandom_range(0, 5)];
        }
        Dice_create = 0;
    }
    if (global.Phase == "Score")
    {
        if (Cat_check == 1)
        {
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = 0;
                Cat_check = 1.1;
                if (place_meeting(x, y, obj_Cat))
                {
                    var var_Cat = instance_place(x, y, obj_Cat);
                    with (var_Cat)
                    {
                        Passive_check = 1;
                    }
                }
                else
                {
                    Cat_check = 0;
                    Dice_check = 1;
                }
            }
        }
        if (Dice_check == 0.5)
        {
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = 0;
                Dice_check = 1;
            }
        }
        else if (Dice_check == 1)
        {
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = 0;
                Dice_check = 1.1;
                if (Dice_ID != -4)
                {
                    with (Dice_ID)
                    {
                        Score_check = 1;
                    }
                    global.Dice_position = Position;
                }
                else
                {
                    Dice_check = 0;
                    with (obj_Ctrl_Cat)
                    {
                        Score_order += 1;
                        Score_start = 1;
                    }
                }
            }
        }
    }
}
else if (global.Game_Pause == 1)
{
}
