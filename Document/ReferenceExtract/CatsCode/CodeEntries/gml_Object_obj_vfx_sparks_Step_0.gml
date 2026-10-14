if (global.Game_Pause == 0)
{
    subimg += 0.2;
    if (subimg >= 2.8)
    {
        instance_destroy();
        exit;
    }
    alpha -= 0.006;
}
else if (global.Game_Pause == 1)
{
}
