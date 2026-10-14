if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    switch (global.Phase)
    {
        case "Shop_wait":
            global.Phase = "Shop_start";
            Reroll_cost = global.Shop_rerollcost;
            with (obj_Ctrl_Cat)
            {
                centerboard_subimg = 2;
            }
            global.Chips_display = "";
            global.Mult_display = "";
            break;
        case "Shop_load":
            for (var var_i = 0; var_i < 2; var_i += 1)
            {
                if (Shop_cat[var_i] != -4)
                {
                    with (instance_create_layer(obj_Dice_tray.x + 44 + (var_i * 84), obj_Dice_tray.y + 92, "Cat", obj_Cat))
                    {
                        Shop_created = 1;
                        Anim_state = 0.2;
                        xscale = 0.56;
                        yscale = 0.56;
                        Cat_pos = var_i;
                        Cat_type = other.Shop_cat[var_i];
                        scr_Cat_setup(Cat_type);
                    }
                }
            }
            for (var var_j = 0; var_j < 3; var_j += 1)
            {
                if (Shop_item[var_j] != -4)
                {
                    with (instance_create_layer(obj_Dice_tray.x + obj_Dice_tray.Set_item_x + (var_j * obj_Dice_tray.Set_item_gap), obj_Dice_tray.y + obj_Dice_tray.Set_item_y, "Item", obj_Item))
                    {
                        Shop_created = 1;
                        Anim_state = 0.2;
                        xscale = 0.3;
                        yscale = 0.3;
                        Item_pos = var_j;
                        Item_type = other.Shop_item[var_j];
                        scr_Item_setup(Item_type, -4);
                    }
                }
            }
            with (instance_create_layer(obj_Dice_tray.x + obj_Dice_tray.Set_ticket_x, obj_Dice_tray.y + obj_Dice_tray.Set_ticket_y, "Item", obj_Ticket))
            {
                Ticket_type = ds_list_find_value(global_Level.Shoplist_ticket, 0);
                scr_Ticket_setup(Ticket_type);
            }
            global.Phase = "Shop";
            with (obj_Ctrl_Cat)
            {
                centerboard_subimg = 2;
            }
            global.Chips_display = "";
            global.Mult_display = "";
            with (obj_Button_Score)
            {
                Text = Text_exit;
            }
            if (!audio_is_playing(bgm_02_Shop))
            {
                audio_sound_gain(bgm_02_Shop, 1, 0);
                var var_music = audio_play_sound(bgm_02_Shop, 99, true, 0, 0, 1);
                audio_sound_gain(var_music, 1, 3600);
            }
            if (audio_is_playing(bgm_01_Intro))
            {
                audio_sound_gain(bgm_01_Intro, 0, 2400);
            }
            break;
        case "Shop_start":
            for (var var_j = 0; var_j < 6; var_j += 1)
            {
                with (obj_Cat)
                {
                    if (Cat_pos == var_j)
                    {
                        ds_list_add(global_Level.Shoplist_cat, Cat_type);
                    }
                }
            }
            if (global.Stage_progress == 1)
            {
                for (var var_i = 0; var_i < 2; var_i += 1)
                {
                    var var_chance = irandom_range(1, 100);
                    if (var_chance <= 15)
                    {
                        Shop_cat[var_i] = scr_Shop_Cat_uncommon(Shoplist_cat);
                    }
                    else
                    {
                        Shop_cat[var_i] = scr_Shop_Cat_common(Shoplist_cat);
                    }
                }
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var var_chance = irandom_range(1, 100);
                    if (var_chance <= 14)
                    {
                        Shop_item[var_j] = scr_Shop_Item_uncommon(Shoplist_item);
                    }
                    else
                    {
                        Shop_item[var_j] = scr_Shop_Item_common(Shoplist_item);
                    }
                }
            }
            else
            {
                for (var var_i = 0; var_i < 2; var_i += 1)
                {
                    var var_chance = irandom_range(1, 100);
                    if (var_chance <= 23)
                    {
                        Shop_cat[var_i] = scr_Shop_Cat_uncommon(Shoplist_cat);
                    }
                    else
                    {
                        Shop_cat[var_i] = scr_Shop_Cat_common(Shoplist_cat);
                    }
                }
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var var_chance = irandom_range(1, 100);
                    if (var_chance <= 2)
                    {
                        Shop_item[var_j] = scr_Shop_Item_rare(Shoplist_item);
                    }
                    else if (var_chance <= 15)
                    {
                        Shop_item[var_j] = scr_Shop_Item_uncommon(Shoplist_item);
                    }
                    else
                    {
                        Shop_item[var_j] = scr_Shop_Item_common(Shoplist_item);
                    }
                }
            }
            ds_list_clear(Shoplist_cat);
            ds_list_clear(Shoplist_item);
            var var_oldcat = 0;
            var var_olditem = 0;
            with (obj_Cat)
            {
                if (Shop_created == 1)
                {
                    var_oldcat = 1;
                }
            }
            with (obj_Item)
            {
                if (Shop_created == 1)
                {
                    var_olditem = 1;
                }
            }
            for (var var_i = 0; var_i < 2; var_i += 1)
            {
                with (instance_create_layer(obj_Dice_tray.x + 44 + (var_i * 84), obj_Dice_tray.y + 92, "Cat", obj_Cat))
                {
                    Shop_created = 1;
                    if (var_oldcat == 1)
                    {
                        Visible = 0;
                        Anim_state = 0.1;
                    }
                    else
                    {
                        Anim_state = 0.2;
                    }
                    xscale = 0.56;
                    yscale = 0.56;
                    Cat_pos = var_i;
                    Cat_type = other.Shop_cat[var_i];
                    scr_Cat_setup(Cat_type);
                }
            }
            for (var var_j = 0; var_j < 3; var_j += 1)
            {
                with (instance_create_layer(obj_Dice_tray.x + obj_Dice_tray.Set_item_x + (var_j * obj_Dice_tray.Set_item_gap), obj_Dice_tray.y + obj_Dice_tray.Set_item_y, "Item", obj_Item))
                {
                    Shop_created = 1;
                    if (var_olditem == 1)
                    {
                        Visible = 0;
                        Anim_state = 0.1;
                    }
                    else
                    {
                        Anim_state = 0.2;
                    }
                    xscale = 0.3;
                    yscale = 0.3;
                    Item_pos = var_j;
                    Item_type = other.Shop_item[var_j];
                    scr_Item_setup(Item_type, -4);
                }
            }
            if (!instance_exists(obj_Ticket))
            {
                with (instance_create_layer(obj_Dice_tray.x + obj_Dice_tray.Set_ticket_x, obj_Dice_tray.y + obj_Dice_tray.Set_ticket_y, "Item", obj_Ticket))
                {
                    Ticket_type = ds_list_find_value(global_Level.Shoplist_ticket, 0);
                    scr_Ticket_setup(Ticket_type);
                }
            }
            Ticket_refresh -= 1;
            if (Ticket_refresh == 0)
            {
                Ticket_refresh = Ticket_refresh_max;
                with (obj_Ticket)
                {
                    Ticket_buy = -1;
                }
            }
            global.Phase = "Shop";
            with (obj_Button_Score)
            {
                Text = Text_exit;
            }
            scr_Save_run();
            scr_Save_cat();
            scr_Save_shop();
            if (!audio_is_playing(bgm_02_Shop))
            {
                audio_sound_gain(bgm_02_Shop, 1, 0);
                var var_music = audio_play_sound(bgm_02_Shop, 99, true, 0, 0, 1);
                audio_sound_gain(var_music, 1, 2000);
            }
            break;
        case "Shop":
            break;
        case "BoonBane_wait":
            global.Phase = "BoonBane_start";
            break;
        case "BoonBane_load":
            for (var var_k = 0; var_k < 3; var_k += 1)
            {
                if (Bane[var_k] != -4)
                {
                    with (instance_create_layer(obj_Dice_tray.x + 89 + (var_k * 174), obj_Dice_tray.y + 64, "Base", obj_Boonbane_choose))
                    {
                        Boon_type = other.Boon[var_k];
                        Bane_type = other.Bane[var_k];
                        Text_boon = scr_Boonbane_text("Boon", Boon_type);
                        Text_bane = scr_Boonbane_text("Bane", Bane_type);
                    }
                }
            }
            global.Phase = "BoonBane";
            break;
        case "BoonBane_start":
            var var_Boons = ds_list_create();
            var var_Banes = ds_list_create();
            for (var var_i = 0; var_i < UnknownEnum.Value_7; var_i += 1)
            {
                ds_list_add(var_Boons, var_i);
                ds_list_add(var_Banes, var_i);
            }
            if (!ds_list_empty(List_boon))
            {
                for (var var_j = 0; var_j < ds_list_size(List_boon); var_j += 1)
                {
                    var var_option = ds_list_find_value(List_boon, var_j);
                    if (ds_list_find_index(var_Boons, var_option) != -1)
                    {
                        ds_list_delete(var_Boons, ds_list_find_index(var_Boons, var_option));
                    }
                }
            }
            if (!ds_list_empty(List_bane))
            {
                for (var var_j = 0; var_j < ds_list_size(List_bane); var_j += 1)
                {
                    var var_option = ds_list_find_value(List_bane, var_j);
                    if (ds_list_find_index(var_Banes, var_option) != -1)
                    {
                        ds_list_delete(var_Banes, ds_list_find_index(var_Banes, var_option));
                    }
                }
            }
            ds_list_shuffle(var_Boons);
            ds_list_shuffle(var_Banes);
            for (var var_get = 0; !ds_list_empty(var_Banes) && var_get < 3; var_get += 1)
            {
                Bane[var_get] = ds_list_find_value(var_Banes, 0);
                ds_list_delete(var_Banes, 0);
                if (scr_Boonbane_tied(Bane[var_get]) == 1)
                {
                    Boon[var_get] = Bane[var_get];
                    if (ds_list_find_index(var_Boons, Bane[var_get]) != -1)
                    {
                        ds_list_delete(var_Boons, ds_list_find_index(var_Boons, Bane[var_get]));
                    }
                }
                else if (!ds_list_empty(var_Boons))
                {
                    while (scr_Boonbane_tied(ds_list_find_value(var_Boons, 0)) == 1)
                    {
                        ds_list_shuffle(var_Boons);
                    }
                    Boon[var_get] = ds_list_find_value(var_Boons, 0);
                    ds_list_delete(var_Boons, 0);
                }
            }
            ds_list_destroy(var_Boons);
            ds_list_destroy(var_Banes);
            global.Phase = "BoonBane";
            scr_Save_run();
            scr_Save_cat();
            for (var var_k = 0; var_k < 3; var_k += 1)
            {
                if (Bane[var_k] != -4)
                {
                    with (instance_create_layer(obj_Dice_tray.x + 89 + (var_k * 174), obj_Dice_tray.y + 64, "Base", obj_Boonbane_choose))
                    {
                        Boon_type = other.Boon[var_k];
                        Bane_type = other.Bane[var_k];
                        Text_boon = scr_Boonbane_text("Boon", Boon_type);
                        Text_bane = scr_Boonbane_text("Bane", Bane_type);
                    }
                }
            }
            break;
        case "BoonBane":
            break;
    }
}
else if (global.Game_Pause == 1)
{
}

enum UnknownEnum
{
    Value_7 = 7
}
