if (global.Game_Pause == 0)
{
    while (sparks_total > 0)
    {
        var var_dist = 148;
        var var_x = x + lengthdir_x(var_dist, dir);
        var var_y = y + lengthdir_y(var_dist, dir);
        while (var_y < (y - 36) || var_y > (y + 36))
        {
            var_dist -= 2;
            var_x = x + lengthdir_x(var_dist, dir);
            var_y = y + lengthdir_y(var_dist, dir);
        }
        var_x += irandom_range(-2, 2);
        var_y += irandom_range(-2, 2);
        with (instance_create_layer(var_x, var_y, "UI", obj_vfx_sparks))
        {
            currentspr = other.sprite;
            rotate = other.dir;
        }
        sparks_total -= 1;
        sprite = choose(spr_vfx_sparks1, spr_vfx_sparks2, spr_vfx_sparks3, spr_vfx_sparks4);
        var var_dir = irandom_range(0, 359);
        while (abs(dir - var_dir) <= 30)
        {
            var_dir = irandom_range(0, 359);
        }
        dir = var_dir;
    }
    instance_destroy();
}
else if (global.Game_Pause == 1)
{
}
