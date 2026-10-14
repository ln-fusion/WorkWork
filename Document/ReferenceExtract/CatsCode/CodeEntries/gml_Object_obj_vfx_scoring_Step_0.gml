if (global.Game_Pause == 0)
{
    if (Hidden == 1)
    {
        Wait_counter += global.deltaTime;
        if (Wait_counter < Wait_counterMax)
        {
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            exit;
        }
        else
        {
            Hidden = -1;
            Text_alpha = 1;
            if (Master != -4)
            {
                if (instance_exists(Master) && Master.object_index != obj_Cat)
                {
                    sprite_index = -1;
                    mask_index = -1;
                }
                with (Master)
                {
                    Anim_state = 1;
                    rotate = 0;
                    rotate_spd = rotate_spdMax;
                    xscale = 1;
                    yscale = 1;
                    scale_spd = scale_spdMax;
                }
            }
        }
    }
    else if (Hidden == 0)
    {
        Wait_counter += global.deltaTime;
        if (Wait_counter >= Wait_counterMax)
        {
            sprite_index = -1;
            mask_index = -1;
            Hidden = -1;
        }
    }
    if (counter == 0 && Cantrip == 0)
    {
        global.Freeze_frame = 1;
    }
    if (counter == 0)
    {
        if (Master != -4 && Master.object_index == obj_Cat)
        {
            vy = -6.2;
            vy_decelerate = 0.78;
            vy_min = 1.4;
            grav_max = 0.06;
            Text_scale = 0.58;
        }
    }
    counter += global.deltaTime;
    if (counter >= counter_max)
    {
        instance_destroy();
        exit;
    }
    if (Text_size == 0)
    {
        Text_scale += 0.16;
        if (Text_scale >= 1.272)
        {
            Text_size = 0.8;
        }
    }
    else if (Text_size == 0.8)
    {
        Text_size = 0.9;
    }
    else if (Text_size == 0.9)
    {
        Text_size = 1;
    }
    else if (Text_size == 1)
    {
        Text_scale -= 0.068;
        if (Text_scale < 0.96)
        {
            Text_size = 2;
        }
    }
    else if (Text_size == 2)
    {
        Text_scale = scr_Approach(Text_scale, 1, 0.05);
        if (Text_scale == 1)
        {
            Text_size = 3;
        }
    }
    if (Sound_create == 0)
    {
        var var_pitch = 0.0128;
        if (global.Pitch_scoring >= 1.32)
        {
            var_pitch = 0.009;
        }
        else if (global.Pitch_scoring >= 1.16)
        {
            var_pitch = 0.011;
        }
        global.Pitch_scoring += var_pitch;
        if (global.Pitch_scoring > global.Pitch_scoring_max)
        {
            global.Pitch_scoring = global.Pitch_scoring_max;
        }
        global.Scoring_spd += global.Scoring_spd_increase;
        switch (Text_color)
        {
            case 10148396:
                audio_play_sound(sfx_Score_points, 80, false, global.Ctrl_SFX, 0, global.Pitch_scoring);
                with (obj_Ctrl_Cat)
                {
                    fontpoints_scale = 1.16;
                    fontpoints_freeze = 1;
                }
                break;
            case 10787638:
                audio_play_sound(sfx_Score_points, 80, false, global.Ctrl_SFX, 0, global.Pitch_scoring);
                break;
            case 5263871:
                audio_play_sound(sfx_Score_mult, 80, false, global.Ctrl_SFX, 0, global.Pitch_scoring);
                with (obj_Ctrl_Cat)
                {
                    fontmult_scale = 1.16;
                    fontmult_freeze = 1;
                }
                break;
            case 5234162:
                audio_play_sound(sfx_UI_money_gain, 80, false, global.Ctrl_SFX, 0, global.Pitch_scoring);
                break;
        }
        Sound_create = 1;
        global.Chips_display = Display_points;
        global.Mult_display = Display_mult;
        var var_total = floor(global.Chips_display * global.Mult_display);
        with (obj_Ctrl_Cat)
        {
            scoreboard_target = floor((var_total / global.Score_needed) * 9);
            if (scoreboard_target > 9)
            {
                scoreboard_target = 9;
                if (scoreboard_subimg >= (scoreboard_target * 2))
                {
                    scoreboard_scale = 1.032;
                    scoreboard_freeze = 1;
                    if (global.Sparks_spd > 2)
                    {
                        instance_create_layer(308, 50, "UI", obj_vfx_sparks_emitter);
                        if (global.Sparks_spd > 5)
                        {
                            instance_create_layer(x, y, "UI", obj_screenshake_norm);
                        }
                    }
                    global.Sparks_spd += 1;
                }
            }
            if (scoreboard_subimg == (scoreboard_target * 2) && scoreboard_subimg >= 4 && scoreboard_subimg < 18)
            {
                scoreboard_subimg -= 0.5;
            }
        }
    }
    vy = scr_Approach(vy, vy_min, vy_decelerate * global.deltaTime);
    if (vy >= vy_min)
    {
        vy_min = grav_max;
    }
    y += (vy * global.deltaTime);
    if (counter >= counter_alpha)
    {
        Text_alpha -= (0.06 * global.deltaTime);
        if (Text_alpha <= 0)
        {
            instance_destroy();
        }
    }
}
else if (global.Game_Pause == 1)
{
}
