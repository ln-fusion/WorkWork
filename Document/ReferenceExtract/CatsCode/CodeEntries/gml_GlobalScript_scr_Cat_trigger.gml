function scr_Cat_trigger(arg0)
{
    for (var var_i = 0; var_i < Passive_max; var_i += 1)
    {
        switch (Passive[var_i])
        {
            case UnknownEnum.Value_3000:
                if (arg0 == 0)
                {
                    global.Mult += Cat_mult[var_i];
                }
                else if (arg0 == 1)
                {
                    global.Mult_next += Cat_mult[var_i];
                    global.Mult += Cat_mult[var_i];
                }
                var var_display = Cat_mult[var_i];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                    mask_index = -1;
                    sprite_index = -1;
                }
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                break;
            case UnknownEnum.Value_3001:
                if (arg0 == 0)
                {
                    global.Chips += Cat_chips[var_i];
                }
                else if (arg0 == 1)
                {
                    global.Chips_next += Cat_chips[var_i];
                    global.Chips += Cat_chips[var_i];
                }
                var var_display = Cat_chips[var_i];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                    mask_index = -1;
                    sprite_index = -1;
                }
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                break;
        }
    }
}

enum UnknownEnum
{
    Value_3000 = 3000,
    Value_3001
}
