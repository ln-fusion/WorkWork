function scr_Cat_score_check()
{
    for (var var_j = 0; var_j < 6; var_j += 1)
    {
        with (obj_Cat)
        {
            if (Cat_pos == var_j)
            {
                for (var var_i = 0; var_i < Passive_max; var_i += 1)
                {
                    var var_trigger = 0;
                    switch (Passive[var_i])
                    {
                        case UnknownEnum.Value_21:
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
                    }
                    if (var_trigger == 1)
                    {
                        global.Passive_scoring += 1;
                        scr_Cat_trigger(0);
                    }
                }
            }
        }
    }
}

enum UnknownEnum
{
    Value_21 = 21
}
