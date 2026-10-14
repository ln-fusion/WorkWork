function scr_Shop_Cat_uncommon(arg0)
{
    var var_Commonlist = ds_list_create();
    ds_list_add(var_Commonlist, UnknownEnum.Value_35, UnknownEnum.Value_36, UnknownEnum.Value_37, UnknownEnum.Value_38, UnknownEnum.Value_39, UnknownEnum.Value_41, UnknownEnum.Value_43, UnknownEnum.Value_45, UnknownEnum.Value_46, UnknownEnum.Value_47, UnknownEnum.Value_48, UnknownEnum.Value_49, UnknownEnum.Value_51, UnknownEnum.Value_53, UnknownEnum.Value_55, UnknownEnum.Value_56);
    for (var var_i = 0; var_i < ds_list_size(arg0); var_i += 1)
    {
        if (ds_list_find_index(var_Commonlist, ds_list_find_value(arg0, var_i)) != -1)
        {
            var var_pos = ds_list_find_index(var_Commonlist, ds_list_find_value(arg0, var_i));
            ds_list_delete(var_Commonlist, var_pos);
        }
    }
    ds_list_shuffle(var_Commonlist);
    var var_cat = ds_list_find_value(var_Commonlist, 0);
    ds_list_destroy(var_Commonlist);
    ds_list_add(arg0, var_cat);
    return var_cat;
}

enum UnknownEnum
{
    Value_35 = 35,
    Value_36,
    Value_37,
    Value_38,
    Value_39,
    Value_41 = 41,
    Value_43 = 43,
    Value_45 = 45,
    Value_46,
    Value_47,
    Value_48,
    Value_49,
    Value_51 = 51,
    Value_53 = 53,
    Value_55 = 55,
    Value_56
}
