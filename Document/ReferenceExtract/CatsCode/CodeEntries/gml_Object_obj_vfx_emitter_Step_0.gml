if (global.Game_Pause == 0)
{
    emit += 1;
    if (emit == 3)
    {
        x_side *= -1;
        random_x = irandom_range(4, 24) * x_side;
        random_y = irandom_range(-4, 30);
        with (instance_create_layer(x + random_x, y - 14 - random_y, "UI", obj_vfx_gains))
        {
            currentspr = other.sprite_emit;
            xscale = other.random_scale;
            yscale = xscale;
        }
        if (random_scale >= 0.6)
        {
            random_scale = choose(0.4, 0.5);
        }
        else
        {
            random_scale = choose(0.6, 0.8, 1);
        }
        emit = 0;
    }
    counter += 1;
    if (counter >= counter_max)
    {
        instance_destroy();
    }
}
else if (global.Game_Pause == 1)
{
}
