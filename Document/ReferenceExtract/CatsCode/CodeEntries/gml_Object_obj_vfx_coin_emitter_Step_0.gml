if (global.Game_Pause == 0)
{
    counter += 1;
    create_counter += 1;
    if (create_counter >= Coin_create)
    {
        var var_dist = 156;
        var var_x = x + lengthdir_x(var_dist, dir);
        var var_y = y + lengthdir_y(var_dist, dir);
        while (var_y < (y - 36) || var_y > (y + 36))
        {
            var_dist -= 1;
            var_x = x + lengthdir_x(var_dist, dir);
            var_y = y + lengthdir_y(var_dist, dir);
        }
        var_x += irandom_range(-2, 2);
        var_y += irandom_range(-2, 2);
        with (instance_create_layer(var_x, var_y, "UI", obj_vfx_coin))
        {
            vx = cos(degtorad(other.dir)) * other.Coin_spd;
            vy = sin(degtorad(other.dir)) * -other.Coin_spd;
        }
        create_counter = 0;
        var var_dir = irandom_range(181, 359);
        while (abs(dir - var_dir) <= 40)
        {
            var_dir = irandom_range(181, 359);
        }
        dir = var_dir;
        if (dir >= 360)
        {
            dir -= 360;
        }
    }
    if (counter >= counter_max)
    {
        instance_destroy();
    }
}
else if (global.Game_Pause == 1)
{
}
