function scr_Shop_Item_rare(arg0)
{
    var var_Commonlist = ds_list_create();
    ds_list_add(var_Commonlist, UnknownEnum.Value_3000, UnknownEnum.Value_3001, UnknownEnum.Value_3002, UnknownEnum.Value_3004, UnknownEnum.Value_3102, UnknownEnum.Value_3103, UnknownEnum.Value_3104, UnknownEnum.Value_3105, UnknownEnum.Value_3106, UnknownEnum.Value_3107);
    for (var var_i = 0; var_i < ds_list_size(arg0); var_i += 1)
    {
        if (ds_list_find_index(var_Commonlist, ds_list_find_value(arg0, var_i)) != -1)
        {
            var var_pos = ds_list_find_index(var_Commonlist, ds_list_find_value(arg0, var_i));
            ds_list_delete(var_Commonlist, var_pos);
        }
    }
    ds_list_shuffle(var_Commonlist);
    var var_item = ds_list_find_value(var_Commonlist, 0);
    ds_list_destroy(var_Commonlist);
    ds_list_add(arg0, var_item);
    return var_item;
}

enum UnknownEnum
{
    Value_3000 = 3000,
    Value_3001,
    Value_3002,
    Value_3004 = 3004,
    Value_3102 = 3102,
    Value_3103,
    Value_3104,
    Value_3105,
    Value_3106,
    Value_3107
}
