function scr_Cat_endround_check()
{
    for (var var_j = 0; var_j < 6; var_j += 1)
    {
        with (obj_Cat)
        {
            if (Cat_pos == var_j)
            {
                for (var var_i = 0; var_i < Passive_max; var_i += 1)
                {
                    switch (Passive[var_i])
                    {
                        case UnknownEnum.Value_1:
                            global.Player_gold += Cat_num[var_i];
                            var var_display = Cat_num[var_i];
                            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                            {
                                Master = other.id;
                                Text = "$" + string(var_display);
                                Text_color = 5234162;
                            }
                            if (Anim_state == 0)
                            {
                                Anim_state = 1;
                            }
                            break;
                        case UnknownEnum.Value_19:
                            if (global.Attempt_score == Cat_num[var_i])
                            {
                                Round_chips[var_i] += Cat_chips[var_i];
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
                        case UnknownEnum.Value_1017:
                            if (global.Round_score == Cat_num[var_i])
                            {
                                global.Player_gold += Cat_num[var_i];
                                var var_display = Cat_num[var_i];
                                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                                {
                                    Master = other.id;
                                    Text = "$" + string(var_display);
                                    Text_color = 5234162;
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
                        case UnknownEnum.Value_1018:
                            if (global.Track_reroll <= Cat_num[var_i])
                            {
                                global.Player_gold += Cat_num[var_i];
                                var var_display = Cat_num[var_i];
                                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                                {
                                    Master = other.id;
                                    Text = "$" + string(var_display);
                                    Text_color = 5234162;
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
                }
            }
        }
    }
}

enum UnknownEnum
{
    Value_1 = 1,
    Value_19 = 19,
    Value_1017 = 1017,
    Value_1018
}
