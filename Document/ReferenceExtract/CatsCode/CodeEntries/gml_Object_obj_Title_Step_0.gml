if (global.Game_Pause == 0)
{
    counter += 1;
    if (counter >= counter_max && Anim_state == -1)
    {
        Anim_state = 0;
        counter = 0;
    }
    switch (Anim_state)
    {
        case 0:
            scale_spd = scale_spdMax;
            target_scale = random_range(0.984, 0.986);
            Anim_state = 1;
            break;
        case 1:
            scale_spd = scr_Approach(scale_spd, 0.004, 0.014);
            xscale = scr_Approach(xscale, target_scale, scale_spd);
            yscale = scr_Approach(yscale, target_scale, scale_spd);
            if (xscale == target_scale && yscale == target_scale)
            {
                target_scale = random_range(1.016, 1.018);
                scale_spd = scale_spdMax;
                Anim_state = 2;
            }
            break;
        case 2:
            scale_spd = scr_Approach(scale_spd, 0.004, 0.014);
            xscale = scr_Approach(xscale, target_scale, scale_spd);
            yscale = scr_Approach(yscale, target_scale, scale_spd);
            if (xscale == target_scale && yscale == target_scale)
            {
                target_scale = 1;
                Anim_state = 3;
            }
            break;
        case 3:
            scale_spd = scr_Approach(scale_spd, 0.004, 0.014);
            xscale = scr_Approach(xscale, target_scale, scale_spd);
            yscale = scr_Approach(yscale, target_scale, scale_spd);
            if (yscale == 1 && xscale == 1)
            {
                Anim_state = -1;
            }
            break;
    }
}
else if (global.Game_Pause == 1)
{
}
