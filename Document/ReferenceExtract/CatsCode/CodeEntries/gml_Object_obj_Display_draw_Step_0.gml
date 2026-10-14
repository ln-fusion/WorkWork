if (global.Game_Pause != 1)
{
    instance_destroy();
    exit;
}
if (instance_exists(Master))
{
    if (Master.Selected != 1)
    {
        instance_destroy();
        exit;
    }
}
