function scr_Shop_Item_uncommon(arg0)
{
    var var_Commonlist = ds_list_create();
    ds_list_add(var_Commonlist, UnknownEnum.Value_2000, UnknownEnum.Value_2001, UnknownEnum.Value_2003, UnknownEnum.Value_2004, UnknownEnum.Value_2006, UnknownEnum.Value_2007, UnknownEnum.Value_2008, UnknownEnum.Value_2009, UnknownEnum.Value_2010, UnknownEnum.Value_2011, UnknownEnum.Value_2012, UnknownEnum.Value_2101, UnknownEnum.Value_2102, UnknownEnum.Value_2103, UnknownEnum.Value_2104, UnknownEnum.Value_2105, UnknownEnum.Value_2106, UnknownEnum.Value_2107);
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
    Value_2000 = 2000,
    Value_2001,
    Value_2003 = 2003,
    Value_2004,
    Value_2006 = 2006,
    Value_2007,
    Value_2008,
    Value_2009,
    Value_2010,
    Value_2011,
    Value_2012,
    Value_2101 = 2101,
    Value_2102,
    Value_2103,
    Value_2104,
    Value_2105,
    Value_2106,
    Value_2107
}
