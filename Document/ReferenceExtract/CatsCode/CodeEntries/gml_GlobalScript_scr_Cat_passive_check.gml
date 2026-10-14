function scr_Cat_passive_check(arg0, arg1)
{
    var var_trigger = 0;
    switch (arg0)
    {
        case UnknownEnum.Value_0:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    var_total += Dice_value[Dice_face];
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "<>":
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        var_total += global.Bling_points;
                                    }
                                    break;
                            }
                        }
                    }
                }
            }
            global.Chips += var_total;
            var_trigger = 1;
            var var_display = var_total;
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "+" + string(var_display);
                Text_color = 10148396;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_2:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_3:
            if (Round_mult[arg1] > 0)
            {
                global.Mult += Round_mult[arg1];
                var_trigger = 1;
                var var_display = Round_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_5:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    Face_next = 6;
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_6:
            var var_even = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if ((Dice_value[Dice_face] % 2) == 0)
                    {
                        var_even += 1;
                    }
                }
            }
            if (var_even == 0)
            {
                global.Mult = global.Mult * Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "x" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_7:
            if (Round_mult[arg1] > 0)
            {
                global.Mult += Round_mult[arg1];
                var_trigger = 1;
                var var_display = Round_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_39:
            var var_mult = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_mult = Dice_value[Dice_face];
                }
                var_mult = floor(var_mult * Cat_mult[arg1]);
                global.Mult += var_mult;
                var_trigger = 1;
                var var_display = var_mult;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_11:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray >= 1)
                {
                    var_total += Dice_value[Dice_face];
                    var_trigger = 1;
                }
            }
            if (var_trigger > 0)
            {
                global.Chips += var_total;
                var var_display = var_total;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_12:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    Face_next = 3;
                }
                if (var_trigger == 0)
                {
                    var_trigger = 1;
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_42:
            var var_check = 0;
            var var_dice = -4;
            for (var var_i = Cat_pos; var_i < 6; var_i += 1)
            {
                var_dice = -4;
                with (obj_Position)
                {
                    if (Position == var_i)
                    {
                        var_dice = Dice_ID;
                    }
                }
                if (var_dice != -4)
                {
                    with (var_dice)
                    {
                        Dice_face = 7 - Dice_face;
                        subimg = Dice_value[Dice_face];
                        scr_Dice_roll_check(Dice_value[Dice_face]);
                    }
                    var_check = 1;
                }
            }
            if (var_check == 1)
            {
                scr_Dice_combo_check(1);
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_14:
            var var_check = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if (Dice_value[Dice_face] > 3)
                    {
                        var_check += 1;
                    }
                }
            }
            if (var_check == 0)
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_15:
            var var_check = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    var_check += 1;
                }
            }
            if (var_check < Cat_num[arg1])
            {
                global.Mult = global.Mult * Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "x" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_16:
            if (global.Round_reroll == Cat_num[arg1])
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_17:
            if (global.Round_reroll > 0)
            {
                global.Chips += (global.Round_reroll * Cat_chips[arg1]);
                var_trigger = 1;
                var var_display = global.Round_reroll * Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_18:
            if (global.Round_score == Cat_num[arg1])
            {
                global.Mult = global.Mult * Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "x" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_19:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_20:
            if (global.Round_score > 0)
            {
                global.Chips += (global.Round_score * Cat_chips[arg1]);
                var_trigger = 1;
                var var_display = global.Round_score * Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_21:
            global.Chips += Round_chips[arg1];
            var_trigger = 1;
            var var_display = Round_chips[arg1];
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "+" + string(var_display);
                Text_color = 10148396;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_29:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "<>":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["<>", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["<>", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_30:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "M":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["M", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["M", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_31:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "$":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["$", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["$", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_32:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "Spade":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["Spade", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["Spade", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_33:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "Heart":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["Heart", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["Heart", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_45:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    Dice_face = other.Cat_pos + 1;
                    subimg = Dice_value[Dice_face];
                    scr_Dice_roll_check(Dice_value[Dice_face]);
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_34:
            if (Round_mult[arg1] > 0)
            {
                global.Mult += Round_mult[arg1];
                var_trigger = 1;
                var var_display = Round_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_22:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            var var_increase = Cat_num[arg1];
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    for (var var_i = 1; var_i < 7; var_i += 1)
                    {
                        Dice_value[var_i] += var_increase;
                    }
                    subimg = Dice_value[Dice_face];
                    instance_create_layer(x, y, "UI", obj_vfx_diceup);
                    if (subimg > 6)
                    {
                        value_scale = 0.6;
                    }
                    else
                    {
                        value_scale = 0.25;
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            scr_Dice_combo_check(1);
            break;
        case UnknownEnum.Value_23:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                if ((Cat_pos + 1) == var_dice.Dice_value[var_dice.Dice_face])
                {
                    var var_payout = (Cat_pos + 1) * var_dice.Dice_value[var_dice.Dice_face];
                    global.Chips += var_payout;
                    global.Mult += var_payout;
                    var_trigger = 1;
                    var var_display = var_payout;
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 10148396;
                    }
                    with (instance_create_layer(x, y - 46, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_24:
            if ((Cat_pos + 1) == Cat_num[arg1])
            {
                global.Mult = global.Mult * Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "x" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_27:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    Face_next = Dice_face;
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_35:
            var var_add = 0;
            if (global.Track_pair > 0)
            {
                var_add = global.Track_pair * Cat_num[arg1];
            }
            global.Mult = global.Mult * (Cat_mult[arg1] + var_add);
            var_trigger = 1;
            var var_display = Cat_mult[arg1] + var_add;
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "x" + string(var_display);
                Text_color = 5263871;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_36:
            var var_add = 0;
            if (global.Track_same3 > 0)
            {
                var_add = global.Track_same3 * Cat_num[arg1];
            }
            global.Mult = global.Mult * (Cat_mult[arg1] + var_add);
            var_trigger = 1;
            var var_display = Cat_mult[arg1] + var_add;
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "x" + string(var_display);
                Text_color = 5263871;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_37:
            var var_list = ds_list_create();
            var var_combo = ds_list_create();
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    ds_list_add(var_list, Dice_value[Dice_face]);
                }
            }
            while (ds_list_size(var_list) >= Cat_num[arg1])
            {
                var var_find = 1;
                var var_value = ds_list_find_value(var_list, 0);
                var var_i = ds_list_size(var_list) - 1;
                while (var_i > -1)
                {
                    if (var_i == 0)
                    {
                        ds_list_delete(var_list, 0);
                    }
                    else if (ds_list_find_value(var_list, var_i) == var_value)
                    {
                        var_find += 1;
                        ds_list_delete(var_list, var_i);
                    }
                    var_i += -1;
                }
                if (var_find >= Cat_num[arg1])
                {
                    ds_list_add(var_combo, var_find);
                }
            }
            if (ds_list_size(var_combo) > 0)
            {
                global.Mult = global.Mult * Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "x" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            ds_list_destroy(var_list);
            ds_list_destroy(var_combo);
            break;
        case UnknownEnum.Value_38:
            if (Round_mult[arg1] > 0)
            {
                global.Mult += Round_mult[arg1];
                var_trigger = 1;
                var var_display = Round_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_40:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                global.Mult = global.Mult * var_value;
                var_trigger = 1;
                var var_display = var_value;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "x" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_41:
            if (Round_mult[arg1] > 0)
            {
                global.Mult += Round_mult[arg1];
                var_trigger = 1;
                var var_display = Round_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_13:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray >= 1)
                {
                    var_total += Dice_value[Dice_face];
                    var_trigger = 1;
                }
            }
            if (var_trigger > 0)
            {
                global.Mult += var_total;
                var var_display = var_total;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_43:
            if (Dice_duplication == 0)
            {
                var var_increase = Cat_num[arg1];
                var var_check = 0;
                var var_dice = -4;
                for (var var_i = Cat_pos; var_i < 6; var_i += 1)
                {
                    var_dice = -4;
                    with (obj_Position)
                    {
                        if (Position == var_i)
                        {
                            var_dice = Dice_ID;
                        }
                    }
                    if (var_dice != -4)
                    {
                        with (var_dice)
                        {
                            Dice_face += var_increase;
                            if (Dice_face > 6)
                            {
                                scr_Dice_overroll();
                                while (Dice_face > 6)
                                {
                                    Dice_face -= 6;
                                }
                            }
                            subimg = Dice_value[Dice_face];
                            scr_Dice_roll_check(Dice_value[Dice_face]);
                        }
                        var_check = 1;
                    }
                }
                if (var_check == 1)
                {
                    scr_Dice_combo_check(1);
                    var_trigger = 1;
                    Anim_state = 1;
                }
                Dice_duplication = 1;
                Passive_num -= 1;
            }
            else if (Dice_duplication == 1)
            {
                var var_loop = 0;
                with (obj_Dice)
                {
                    if (Rolling != 0)
                    {
                        var_loop = 1;
                    }
                }
                if (var_loop == 1)
                {
                    Passive_num -= 1;
                }
                else
                {
                    Dice_duplication = 0;
                }
            }
            break;
        case UnknownEnum.Value_44:
            if (Dice_duplication == 0)
            {
                var var_check = 0;
                var var_increase = Cat_num[arg1];
                with (obj_Dice)
                {
                    if (Dice_tray > 0)
                    {
                        Dice_face += var_increase;
                        if (Dice_face > 6)
                        {
                            scr_Dice_overroll();
                            while (Dice_face > 6)
                            {
                                Dice_face -= 6;
                            }
                        }
                        subimg = Dice_value[Dice_face];
                        scr_Dice_roll_check(Dice_value[Dice_face]);
                        var_check += 1;
                    }
                }
                Dice_duplication = 1;
                Passive_num -= 1;
                if (var_check > 0)
                {
                    var_trigger = 1;
                    Anim_state = 1;
                }
            }
            else if (Dice_duplication == 1)
            {
                var var_loop = 0;
                with (obj_Dice)
                {
                    if (Rolling != 0)
                    {
                        var_loop = 1;
                    }
                }
                if (var_loop == 1)
                {
                    Passive_num -= 1;
                }
                else
                {
                    if (Round_mult[arg1] > 0)
                    {
                        global.Mult += Round_mult[arg1];
                        var var_display = Round_mult[arg1];
                        with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                        {
                            Master = other.id;
                            Text = "+" + string(var_display);
                            Text_color = 5263871;
                        }
                        if (Anim_state == 0)
                        {
                            Anim_state = 1;
                            var_trigger = 1;
                        }
                    }
                    Dice_duplication = 0;
                }
            }
            break;
        case UnknownEnum.Value_47:
            global.Chips += Round_chips[arg1];
            var_trigger = 1;
            var var_display = Round_chips[arg1];
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "+" + string(var_display);
                Text_color = 10148396;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_48:
            if (Dice_duplication == 0)
            {
                with (obj_Dice)
                {
                    if (Dice_tray > 0)
                    {
                        if (Face_next > 0)
                        {
                            Dice_face = Face_next;
                            Face_next = 0;
                        }
                        else
                        {
                            Dice_face = choose(1, 2, 3, 4, 5, 6);
                        }
                        Rolling = 1.05;
                        Draw_effect = 0;
                        spin = irandom_range(26, 28);
                    }
                }
                global.Round_reroll += Cat_num[arg1];
                Dice_duplication = 1;
                Passive_num -= 1;
                var_trigger = 1;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+R";
                    Text_color = 10787638;
                }
                Anim_state = 1;
            }
            else if (Dice_duplication == 1)
            {
                var var_check = 0;
                with (obj_Dice)
                {
                    if (Rolling != 0)
                    {
                        var_check = 1;
                    }
                }
                if (var_check == 1)
                {
                    Passive_num -= 1;
                }
                else
                {
                    Dice_duplication = 0;
                }
            }
            break;
        case UnknownEnum.Value_49:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                var var_check = 0;
                with (obj_Position)
                {
                    if (Position == (other.Cat_pos - 1))
                    {
                        if (Dice_ID != -4)
                        {
                            if (Dice_ID.Dice_value[Dice_ID.Dice_face] == (var_dice.Dice_value[var_dice.Dice_face] - other.Cat_num[arg1]))
                            {
                                var_check += 1;
                            }
                        }
                    }
                }
                with (obj_Position)
                {
                    if (Position == (other.Cat_pos + 1))
                    {
                        if (Dice_ID != -4)
                        {
                            if (Dice_ID.Dice_value[Dice_ID.Dice_face] == (var_dice.Dice_value[var_dice.Dice_face] + other.Cat_num[arg1]))
                            {
                                var_check += 1;
                            }
                        }
                    }
                }
                if (var_check == 2)
                {
                    global.Mult = global.Mult * var_dice.Dice_value[var_dice.Dice_face];
                    var_trigger = 1;
                    var var_display = var_dice.Dice_value[var_dice.Dice_face];
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "x" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_50:
            if (Round_mult[arg1] > 0)
            {
                global.Mult += Round_mult[arg1];
                var_trigger = 1;
                var var_display = Round_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_51:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "Boost":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["Boost", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["Boost", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_52:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "SS":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["SS", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["SS", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_53:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    Dice_Catagain += other.Cat_num[arg1];
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_54:
            if (Dice_duplication == 0)
            {
                var var_dice = -4;
                with (obj_Position)
                {
                    if (Position == other.Cat_pos)
                    {
                        var_dice = Dice_ID;
                    }
                }
                if (var_dice != -4)
                {
                    repeat (Cat_num[arg1])
                    {
                        with (var_dice)
                        {
                            with (instance_create_layer(x, y, "Dice", obj_Dice))
                            {
                                Master = other.Master;
                                subimg_outline = other.subimg_outline;
                                scr_Dice_setup(other.id);
                                Dice_face = other.Dice_face;
                                with (obj_Dice_tray)
                                {
                                    Dice_total += 1;
                                }
                                Dice_tray = obj_Dice_tray.Dice_total;
                                spin = 0;
                                subimg = Dice_value[Dice_face];
                                subimg_outline = other.subimg_outline;
                                Rolling = 1.01;
                            }
                        }
                        scr_Dice_duplication();
                    }
                    var_trigger = 1;
                    Anim_state = 1;
                }
                Dice_duplication = 1;
                Passive_num -= 1;
            }
            else if (Dice_duplication == 1)
            {
                var var_check = 0;
                with (obj_Dice)
                {
                    if (Rolling != 0)
                    {
                        var_check = 1;
                    }
                }
                if (var_check == 1)
                {
                    Passive_num -= 1;
                }
                else
                {
                    Dice_duplication = 0;
                }
            }
            break;
        case UnknownEnum.Value_55:
            var var_check = 0;
            var var_list = ds_list_create();
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    ds_list_add(var_list, Dice_value[Dice_face]);
                }
            }
            if (ds_list_size(var_list) == 6)
            {
                ds_list_sort(var_list, true);
                var var_value = -1;
                var var_total = 0;
                for (var var_g = 0; var_g < 6; var_g += 1)
                {
                    if (ds_list_find_value(var_list, var_g) > var_value)
                    {
                        var_total += 1;
                        var_value = ds_list_find_value(var_list, var_g);
                    }
                }
                if (var_total == 6)
                {
                    var_check = 1;
                }
            }
            ds_list_destroy(var_list);
            if (var_check == 1)
            {
                Round_mult[arg1] += Cat_mult[arg1] / 2;
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_xmult;
                }
            }
            global.Mult = global.Mult * Round_mult[arg1];
            var_trigger = 1;
            var var_display = Round_mult[arg1];
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "x" + string(var_display);
                Text_color = 5263871;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_56:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var var_check = 0;
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "X2":
                                    var var_num = Dice_effect[Dice_face][var_i][1] + 1;
                                    array_delete(Dice_effect[Dice_face], var_i, 1);
                                    array_insert(Dice_effect[Dice_face], var_i, ["X2", var_num]);
                                    var_check = 1;
                                    break;
                            }
                        }
                    }
                    if (var_check == 0)
                    {
                        array_push(Dice_effect[Dice_face], ["X2", 1]);
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1000:
            global.Mult += Cat_mult[arg1];
            var_trigger = 1;
            var var_display = Cat_mult[arg1];
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "+" + string(var_display);
                Text_color = 5263871;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_1001:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                var var_value = -1;
                var var_check = 0;
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                with (obj_Dice)
                {
                    if (id != var_dice && Dice_tray == -1)
                    {
                        if (Dice_value[Dice_face] >= var_value)
                        {
                            var_check = 1;
                        }
                    }
                }
                if (var_check == 0)
                {
                    global.Mult += Cat_mult[arg1];
                    var_trigger = 1;
                    var var_display = Cat_mult[arg1];
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1002:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                var var_value = -1;
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                if (var_value == global.DicePrevious_value)
                {
                    global.Mult += var_value;
                    var_trigger = 1;
                    var var_display = var_value;
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1003:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    var_total += Dice_value[Dice_face];
                }
            }
            if (var_total <= Cat_num[arg1])
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1004:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    var_total += Dice_value[Dice_face];
                }
            }
            if (var_total >= Cat_num[arg1])
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1005:
            var var_select = irandom_range(0, instance_number(obj_Dice) - 1);
            var var_dice = instance_find(obj_Dice, var_select);
            var var_value = 0;
            with (var_dice)
            {
                var_value = Dice_value[Dice_face];
            }
            if (var_dice != -4)
            {
                global.Mult += var_value;
                var_trigger = 1;
                var var_display = var_value;
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1006:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                var var_total = 0;
                with (obj_Dice)
                {
                    if (Dice_tray == -1 && id != var_dice)
                    {
                        if (Dice_value[Dice_face] == var_value)
                        {
                            var_total += 1;
                        }
                    }
                }
                if (var_total > 0)
                {
                    global.Mult += (Cat_mult[arg1] * var_total);
                    var_trigger = 1;
                    var var_display = Cat_mult[arg1] * var_total;
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1007:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                var var_total = 0;
                with (obj_Dice)
                {
                    if (Dice_tray == -1 && id != var_dice)
                    {
                        if (Dice_value[Dice_face] != var_value)
                        {
                            var_total += 1;
                        }
                    }
                }
                if (var_total > 0)
                {
                    global.Mult += (Cat_mult[arg1] * var_total);
                    var_trigger = 1;
                    var var_display = Cat_mult[arg1] * var_total;
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1008:
            var var_even = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if ((Dice_value[Dice_face] % 2) == 0)
                    {
                        var_even += 1;
                    }
                }
            }
            if (var_even == 0)
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1009:
            var var_odd = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if ((Dice_value[Dice_face] % 2) > 0)
                    {
                        var_odd += 1;
                    }
                }
            }
            if (var_odd == 0)
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1010:
            global.Chips += Cat_chips[arg1];
            var_trigger = 1;
            var var_display = Cat_chips[arg1];
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "+" + string(var_display);
                Text_color = 10148396;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_1011:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                var var_total = 0;
                with (obj_Dice)
                {
                    if (Dice_tray == -1 && id != var_dice)
                    {
                        if (Dice_value[Dice_face] == var_value)
                        {
                            var_total += 1;
                        }
                    }
                }
                if (var_total > 0)
                {
                    global.Chips += (Cat_chips[arg1] * var_total);
                    var_trigger = 1;
                    var var_display = Cat_chips[arg1] * var_total;
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 10148396;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1012:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                var var_total = 0;
                with (obj_Dice)
                {
                    if (Dice_tray == -1 && id != var_dice)
                    {
                        if (Dice_value[Dice_face] != var_value)
                        {
                            var_total += 1;
                        }
                    }
                }
                if (var_total > 0)
                {
                    global.Chips += (Cat_chips[arg1] * var_total);
                    var_trigger = 1;
                    var var_display = Cat_chips[arg1] * var_total;
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 10148396;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1013:
            var var_even = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if ((Dice_value[Dice_face] % 2) == 0)
                    {
                        var_even += 1;
                    }
                }
            }
            if (var_even == 0)
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1014:
            var var_odd = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if ((Dice_value[Dice_face] % 2) > 0)
                    {
                        var_odd += 1;
                    }
                }
            }
            if (var_odd == 0)
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1015:
            var var_points = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_points = Dice_value[Dice_face];
                }
                Round_chips[arg1] += var_points;
                with (instance_create_layer(x, y, "UI", obj_vfx_emitter))
                {
                    Master = other.id;
                    sprite_emit = spr_vfx_pluspoints;
                }
            }
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1016:
            if (global.Chips <= Cat_chips[arg1])
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1019:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == (other.Cat_pos + 1))
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                var var_increase = Cat_num[arg1];
                with (var_dice)
                {
                    Dice_value[Dice_face] += var_increase;
                    subimg = Dice_value[Dice_face];
                    instance_create_layer(x, y, "UI", obj_vfx_diceup);
                    if (subimg > 6)
                    {
                        value_scale = 0.6;
                    }
                    else
                    {
                        value_scale = 0.25;
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_1021:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                var var_increase = Cat_num[arg1];
                with (var_dice)
                {
                    if ((Dice_value[Dice_face] % 2) != 0)
                    {
                        Dice_face += var_increase;
                        while (Dice_face > 6)
                        {
                            Dice_face -= 6;
                        }
                        subimg = Dice_value[Dice_face];
                        scr_Dice_roll_check(Dice_value[Dice_face]);
                        var_trigger = 1;
                    }
                }
                if (var_trigger > 0)
                {
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_1022:
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                var var_decrease = Cat_num[arg1];
                with (var_dice)
                {
                    if ((Dice_value[Dice_face] % 2) == 0)
                    {
                        Dice_face -= var_decrease;
                        while (Dice_face < 1)
                        {
                            Dice_face += 6;
                        }
                        subimg = Dice_value[Dice_face];
                        scr_Dice_roll_check(Dice_value[Dice_face]);
                        var_trigger = 1;
                    }
                }
                if (var_trigger > 0)
                {
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_2000:
            var var_value = 0;
            var var_dice = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            if (var_dice != -4)
            {
                with (var_dice)
                {
                    var_value = Dice_value[Dice_face];
                }
                if (var_value >= Cat_num[arg1])
                {
                    global.Mult += Cat_mult[arg1];
                    var_trigger = 1;
                    var var_display = Cat_mult[arg1];
                    with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                    {
                        Master = other.id;
                        Text = "+" + string(var_display);
                        Text_color = 5263871;
                    }
                    Anim_state = 1;
                }
            }
            break;
        case UnknownEnum.Value_2001:
            if (global.Passive_scoring == 0)
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2002:
            if (Cat_moved == 0)
            {
                global.Mult += Cat_mult[arg1];
                var_trigger = 1;
                var var_display = Cat_mult[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 5263871;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2003:
            var var_dicelist = ds_list_create();
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    var var_value = Dice_value[Dice_face];
                    if (array_length(Dice_effect[Dice_face]) > 0)
                    {
                        for (var var_i = 0; var_i < array_length(Dice_effect[Dice_face]); var_i += 1)
                        {
                            switch (Dice_effect[Dice_face][var_i][0])
                            {
                                case "<>":
                                    repeat (Dice_effect[Dice_face][var_i][1])
                                    {
                                        var_value += global.Bling_points;
                                    }
                                    break;
                            }
                        }
                    }
                    ds_list_add(var_dicelist, var_value);
                }
            }
            ds_list_sort(var_dicelist, false);
            if (!ds_list_empty(var_dicelist))
            {
                global.Chips += ds_list_find_value(var_dicelist, 0);
                var_trigger = 1;
                var var_display = ds_list_find_value(var_dicelist, 0);
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            ds_list_destroy(var_dicelist);
            break;
        case UnknownEnum.Value_2004:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    var_total += Dice_value[Dice_face];
                }
            }
            if (var_total <= Cat_num[arg1])
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2005:
            var var_check = 0;
            var var_pos = Cat_pos;
            with (obj_Cat)
            {
                if (id != other.id)
                {
                    if (Cat_pos > var_pos)
                    {
                        var_check = 1;
                    }
                }
            }
            if (var_check == 0)
            {
                global.Chips += Cat_chips[arg1];
                var_trigger = 1;
                var var_display = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2006:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2007:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2008:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2009:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2010:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2011:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2012:
            if (Round_chips[arg1] > 0)
            {
                global.Chips += Round_chips[arg1];
                var_trigger = 1;
                var var_display = Round_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_display);
                    Text_color = 10148396;
                }
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2015:
            var var_dice = -4;
            var var_dice2 = -4;
            var var_face = 0;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
                else if (Position == (other.Cat_pos + 1))
                {
                    var_dice2 = Dice_ID;
                }
            }
            if (var_dice != -4 && var_dice2 != -4)
            {
                with (var_dice)
                {
                    var_face = Dice_face;
                }
                with (var_dice2)
                {
                    Dice_face = var_face;
                    subimg = Dice_value[Dice_face];
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            break;
        case UnknownEnum.Value_2016:
            var var_dice = -4;
            var var_dice2 = -4;
            with (obj_Position)
            {
                if (Position == other.Cat_pos)
                {
                    var_dice = Dice_ID;
                }
            }
            var var_dicelist = ds_list_create();
            with (obj_Dice)
            {
                if (Score_num > 0)
                {
                    ds_list_add(var_dicelist, id);
                }
            }
            if (var_dice != -4 && !ds_list_empty(var_dicelist))
            {
                ds_list_shuffle(var_dicelist);
                var_dice2 = ds_list_find_value(var_dicelist, 0);
                var var_x = 0;
                with (var_dice)
                {
                    var_x = x;
                    x = var_dice2.x;
                    with (instance_place(x, y, obj_Position))
                    {
                        Dice_ID = var_dice;
                    }
                }
                with (var_dice2)
                {
                    x = var_x;
                    with (instance_place(x, y, obj_Position))
                    {
                        Dice_ID = var_dice2;
                    }
                }
                var_trigger = 1;
                Anim_state = 1;
            }
            ds_list_destroy(var_dicelist);
            break;
        case UnknownEnum.Value_3002:
            global.Mult = global.Mult * Cat_mult[arg1];
            var_trigger = 1;
            var var_display = Cat_mult[arg1];
            with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
            {
                Master = other.id;
                Text = "x" + string(var_display);
                Text_color = 5263871;
            }
            Anim_state = 1;
            break;
        case UnknownEnum.Value_3005:
            var var_total = 0;
            with (obj_Dice)
            {
                if (Dice_tray == -1)
                {
                    if (Dice_value[Dice_face] == 6)
                    {
                        var_total += 1;
                    }
                }
            }
            if (var_total == 3)
            {
                global.Chips += Cat_chips[arg1];
                global.Mult += Cat_mult[arg1];
                global.Player_gold += Cat_num[arg1];
                var_trigger = 1;
                var var_chips = Cat_chips[arg1];
                with (instance_create_layer(x, y - 70, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_chips);
                    Text_color = 10148396;
                }
                var var_mult = Cat_mult[arg1];
                with (instance_create_layer(x, y - 46, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "+" + string(var_mult);
                    Text_color = 5263871;
                }
                var var_money = Cat_num[arg1];
                with (instance_create_layer(x, y - 22, "UI", obj_vfx_scoring))
                {
                    Master = other.id;
                    Text = "$" + string(var_money);
                    Text_color = 5234162;
                }
                Anim_state = 1;
            }
            break;
    }
    if (var_trigger == 1)
    {
        global.Passive_scoring += 1;
        scr_Cat_trigger(0);
    }
    Passive_check = 1;
    return var_trigger;
}

enum UnknownEnum
{
    Value_0,
    Value_2 = 2,
    Value_3,
    Value_5 = 5,
    Value_6,
    Value_7,
    Value_11 = 11,
    Value_12,
    Value_13,
    Value_14,
    Value_15,
    Value_16,
    Value_17,
    Value_18,
    Value_19,
    Value_20,
    Value_21,
    Value_22,
    Value_23,
    Value_24,
    Value_27 = 27,
    Value_29 = 29,
    Value_30,
    Value_31,
    Value_32,
    Value_33,
    Value_34,
    Value_35,
    Value_36,
    Value_37,
    Value_38,
    Value_39,
    Value_40,
    Value_41,
    Value_42,
    Value_43,
    Value_44,
    Value_45,
    Value_47 = 47,
    Value_48,
    Value_49,
    Value_50,
    Value_51,
    Value_52,
    Value_53,
    Value_54,
    Value_55,
    Value_56,
    Value_1000 = 1000,
    Value_1001,
    Value_1002,
    Value_1003,
    Value_1004,
    Value_1005,
    Value_1006,
    Value_1007,
    Value_1008,
    Value_1009,
    Value_1010,
    Value_1011,
    Value_1012,
    Value_1013,
    Value_1014,
    Value_1015,
    Value_1016,
    Value_1019 = 1019,
    Value_1021 = 1021,
    Value_1022,
    Value_2000 = 2000,
    Value_2001,
    Value_2002,
    Value_2003,
    Value_2004,
    Value_2005,
    Value_2006,
    Value_2007,
    Value_2008,
    Value_2009,
    Value_2010,
    Value_2011,
    Value_2012,
    Value_2015 = 2015,
    Value_2016,
    Value_3002 = 3002,
    Value_3005 = 3005
}
