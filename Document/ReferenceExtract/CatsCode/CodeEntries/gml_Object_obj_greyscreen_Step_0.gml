if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (!instance_exists(Master))
    {
        instance_destroy();
        exit;
    }
}
else if (global.Game_Pause == 1)
{
}
