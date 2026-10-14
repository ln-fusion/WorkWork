function scr_Cat_dicescore_check(arg0, arg1)
{
    var var_trigger = 0;
    switch (arg0)
    {
        case UnknownEnum.Value_2:
            if (global.Dice_value == 6)
            {
                Round_chips[arg1] += Cat_chips[arg1];
                var_trigger = 1;
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                else
                {
                    Anim_delay += 1;
                }
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_pluspoints;
                }
            }
            break;
        case UnknownEnum.Value_3:
            if (global.Dice_position == Cat_pos)
            {
                Round_mult[arg1] += Cat_mult[arg1];
                var_trigger = 1;
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                else
                {
                    Anim_delay += 1;
                }
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_plusmult;
                }
            }
            break;
        case UnknownEnum.Value_4:
            if (global.Dice_value == 1)
            {
                global.Chips += Cat_chips[arg1];
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display1 = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display1);
                    Text_color = 10148396;
                    mask_index = -1;
                    sprite_index = -1;
                }
                var var_display2 = Cat_mult[arg1];
                with (instance_create_layer(x, y - 46, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display2);
                    Text_color = 5263871;
                    mask_index = -1;
                    sprite_index = -1;
                }
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_7:
            if ((global.Dice_value % 2) == 0)
            {
                Round_mult[arg1] += Cat_mult[arg1];
                var_trigger = 1;
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                else
                {
                    Anim_delay += 1;
                }
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_plusmult;
                }
            }
            break;
        case UnknownEnum.Value_9:
            if (global.Dice_value == 4)
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
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
            }
            break;
        case UnknownEnum.Value_10:
            if (global.Dice_value == 5)
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
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
            }
            break;
        case UnknownEnum.Value_34:
            Round_mult[arg1] += Cat_mult[arg1];
            var_trigger = 1;
            if (Anim_state == 0)
            {
                Anim_state = 1;
            }
            else
            {
                Anim_delay += 1;
            }
            with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
            {
                Master = other.id;
                sprite_emit = spr_vfx_plusmult;
            }
            break;
        case UnknownEnum.Value_38:
            if (global.Dice_value == 1)
            {
                Round_mult[arg1] += Cat_mult[arg1];
                var_trigger = 1;
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                else
                {
                    Anim_delay += 1;
                }
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_plusmult;
                }
            }
            break;
        case UnknownEnum.Value_41:
            if (global.Dice_position == Cat_pos && global.Dice_value == 6)
            {
                Round_mult[arg1] += Cat_mult[arg1];
                var_trigger = 1;
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                else
                {
                    Anim_delay += 1;
                }
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_plusmult;
                }
            }
            break;
        case UnknownEnum.Value_1020:
            if (global.Dice_position == Cat_pos)
            {
                global.Round_reroll += Cat_num[arg1];
                var_trigger = 1;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+R";
                    Text_color = 10787638;
                }
                if (Anim_state == 0)
                {
                    Anim_state = 1;
                }
                else
                {
                    Anim_delay += 1;
                }
            }
            break;
    }
    if (var_trigger == 1)
    {
        scr_Cat_trigger(0);
    }
    Passive_check = 2;
    return var_trigger;
}

enum UnknownEnum
{
    Value_2 = 2,
    Value_3,
    Value_4,
    Value_7 = 7,
    Value_9 = 9,
    Value_10,
    Value_34 = 34,
    Value_38 = 38,
    Value_41 = 41,
    Value_1020 = 1020
}
