if (global.Game_Pause == 0)
{
    subimg += 0.2;
    if (subimg >= 5.8)
    {
        subimg = 0;
    }
    alpha -= 0.0042;
    if (alpha <= 0)
    {
        instance_destroy();
        exit;
    }
    vx = scr_Approach(vx, 0, fric);
    vy = scr_Approach(vy, grav_max, grav);
    if ((y + vy) > (room_height - global.Camera_offset_y))
    {
        vy *= -0.88;
    }
    if ((x + vx) < -abs(global.Camera_offset_x) || (x + vx) > (room_width + abs(global.Camera_offset_x)))
    {
        vx *= -0.9;
    }
    x += vx;
    y += vy;
}
else if (global.Game_Pause == 1)
{
}
