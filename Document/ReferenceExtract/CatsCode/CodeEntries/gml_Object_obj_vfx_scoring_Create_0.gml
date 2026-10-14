Cantrip = 0;
Master = -4;
counter = 0;
counter_alpha = 26;
counter_max = 90;
vy = -3.9;
vy_min = 0.12;
vy_decelerate = 0.42;
grav_max = 0.09;
Sound_create = 0;
Text = "";
Text_size = 0;
Text_scale = 0.72;
Text_angle = 0;
Text_color = 16777215;
Text_alpha = 1;
Display_points = global.Chips;
Display_mult = global.Mult;
Hidden = 0;
Wait_counter = 0;
Wait_counterMax = 21 - global.Scoring_spd;
if (place_meeting(x, y, obj_vfx_scoring))
{
    Hidden = 1;
    Text_alpha = 0;
    var var_amt = 0;
    with (obj_vfx_scoring)
    {
        if (place_meeting(x, y, other.id))
        {
            var_amt += 1;
        }
    }
    Wait_counterMax = (21 - global.Scoring_spd) * var_amt;
}
if (Wait_counterMax < 3)
{
    Wait_counterMax = 3;
}
