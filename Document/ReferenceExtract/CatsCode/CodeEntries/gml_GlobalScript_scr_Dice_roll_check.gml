function scr_Dice_roll_check(arg0)
{
    if (global.Pointsplus_4high > 0)
    {
        if (arg0 >= 4)
        {
            global.Chips += global.Pointsplus_4high;
            global.Chips_next += global.Pointsplus_4high;
        }
    }
    if (global.Pointsminus_3low > 0)
    {
        if (arg0 <= 3)
        {
            global.Chips -= global.Pointsminus_3low;
            global.Chips_next -= global.Pointsminus_3low;
        }
    }
    if (global.Multplus_2low > 0)
    {
        if (arg0 <= 2)
        {
            global.Mult += global.Multplus_2low;
            global.Mult_next += global.Multplus_2low;
        }
    }
    if (global.Multminus_6high > 0)
    {
        if (arg0 >= 6)
        {
            global.Mult -= global.Multminus_6high;
            global.Mult_next -= global.Multminus_6high;
        }
    }
    if (array_length(Dice_effect[Dice_face]) > 0)
    {
        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
        {
            switch (Dice_effect[Dice_face][var_i][0])
            {
                case "^R":
                    repeat (Dice_effect[Dice_face][var_i][1])
                    {
                        global.Round_reroll += 1;
                    }
                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+R";
                        Text_color = 10787638;
                        Cantrip = 1;
                    }
                    Moused_over = 2;
                    break;
                case "^Add":
                    var var_display = 0;
                    repeat (Dice_effect[Dice_face][var_i][1])
                    {
                        global.Mult_next += 1;
                        global.Mult += 1;
                        var_display += 1;
                    }
                    with (instance_create_layer(x, y - 16, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                        Cantrip = 1;
                    }
                    Moused_over = 2;
                    break;
            }
        }
    }
    var var_trigger = 0;
    for (var var_j = 0; var_j < 6; var_j += 1)
    {
        with (obj_Cat)
        {
            if (Cat_pos == var_j)
            {
                for (var var_i = 0; var_i < Passive_max; var_i += 1)
                {
                    var_trigger = 0;
                    if (Passive[var_i] != -4)
                    {
                        switch (Passive[var_i])
                        {
                            case UnknownEnum.Value_12:
                                if (arg0 == 3)
                                {
                                    Cat_track[var_i] += 1;
                                    if (Cat_track[var_i] == 3)
                                    {
                                        Round_chips[var_i] += Cat_chips[var_i];
                                        Cat_track[var_i] = 0;
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
                                }
                                break;
                            case UnknownEnum.Value_38:
                                if (arg0 == 1)
                                {
                                    Round_mult[var_i] += Cat_mult[var_i];
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
                            case UnknownEnum.Value_47:
                                Round_chips[var_i] += Cat_chips[var_i];
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
                                break;
                            case UnknownEnum.Value_2006:
                                if (arg0 == 1)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                            case UnknownEnum.Value_2007:
                                if (arg0 == 2)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                            case UnknownEnum.Value_2008:
                                if (arg0 == 3)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                            case UnknownEnum.Value_2009:
                                if (arg0 == 4)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                            case UnknownEnum.Value_2010:
                                if (arg0 == 5)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                            case UnknownEnum.Value_2011:
                                if (arg0 == 6)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                            case UnknownEnum.Value_2012:
                                if (arg0 == 0)
                                {
                                    Round_chips[var_i] += Cat_chips[var_i];
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
                        }
                    }
                }
                if (var_trigger == 1)
                {
                    scr_Cat_trigger(1);
                }
            }
        }
    }
}

enum UnknownEnum
{
    Value_12 = 12,
    Value_38 = 38,
    Value_47 = 47,
    Value_2006 = 2006,
    Value_2007,
    Value_2008,
    Value_2009,
    Value_2010,
    Value_2011,
    Value_2012
}
