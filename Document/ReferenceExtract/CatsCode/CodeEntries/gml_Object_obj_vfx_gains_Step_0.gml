if (global.Game_Pause == 0)
{
    vy = scr_Approach(vy, 0.2, 0.03);
    y += -vy;
    subimg += (0.2 * random_spd);
    if (subimg >= 7.9)
    {
        subimg = 7;
    }
    alpha -= (0.01 * random_spd);
    if (alpha <= 0)
    {
        instance_destroy();
    }
}
else if (global.Game_Pause == 1)
{
}
