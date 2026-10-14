if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (global.Phase == "Shop")
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
        {
            if (Create_cover == 0)
            {
                if (obj_Cursor.Holding == "Cat")
                {
                    var var_sell = 0;
                    with (obj_Cat)
                    {
                        if (Shop_created == 0 && Selected == 1)
                        {
                            var_sell += ceil(0.5 * Cat_cost);
                            with (obj_Item)
                            {
                                if (Master == other.id)
                                {
                                    var_sell += ceil(0.5 * Item_cost);
                                }
                            }
                        }
                    }
                    with (instance_create_layer(x, y, "Dice", obj_Dice_trayCover))
                    {
                        Sell_value = var_sell;
                    }
                }
                else if (obj_Cursor.Holding == "Item")
                {
                    var var_sell = 0;
                    with (obj_Item)
                    {
                        if (Shop_created == 0 && Selected == 1)
                        {
                            var_sell += ceil(0.5 * Item_cost);
                        }
                    }
                    with (instance_create_layer(x, y, "Dice", obj_Dice_trayCover))
                    {
                        Sell_value = var_sell;
                    }
                }
                Create_cover = 1;
            }
        }
        else
        {
            Create_cover = 0;
        }
    }
    else if (global.Phase == "BoonBane")
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Boonbane_choose))
        {
            Text = Text_body2;
        }
        else
        {
            Text = Text_body1;
        }
    }
}
else if (global.Game_Pause == 1)
{
}
