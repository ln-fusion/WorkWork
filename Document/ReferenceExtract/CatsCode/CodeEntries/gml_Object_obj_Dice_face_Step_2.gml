if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (Skip == 1)
    {
        Skip = 0;
        exit;
    }
    if (!instance_exists(Master))
    {
        instance_destroy();
        exit;
    }
    if (global.Escape || global.Lmouse_pressed || global.Rmouse_pressed || global.Space_pressed)
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
        with (obj_Dice_face)
        {
            if (Master == other.Master)
            {
                instance_destroy();
            }
        }
        with (obj_greyscreen)
        {
            if (Master == other.Master)
            {
                instance_destroy();
            }
        }
    }
}
else if (global.Game_Pause == 1)
{
}
