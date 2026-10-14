function scr_Shop_Cat_common(arg0)
{
    var var_Commonlist = ds_list_create();
    ds_list_add(var_Commonlist, UnknownEnum.Value_0, UnknownEnum.Value_1, UnknownEnum.Value_2, UnknownEnum.Value_3, UnknownEnum.Value_4, UnknownEnum.Value_5, UnknownEnum.Value_6, UnknownEnum.Value_7, UnknownEnum.Value_8, UnknownEnum.Value_9, UnknownEnum.Value_10, UnknownEnum.Value_12, UnknownEnum.Value_14, UnknownEnum.Value_15, UnknownEnum.Value_16, UnknownEnum.Value_17, UnknownEnum.Value_18, UnknownEnum.Value_19, UnknownEnum.Value_20, UnknownEnum.Value_21, UnknownEnum.Value_22, UnknownEnum.Value_23, UnknownEnum.Value_24, UnknownEnum.Value_25, UnknownEnum.Value_26, UnknownEnum.Value_27, UnknownEnum.Value_29, UnknownEnum.Value_30);
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
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_7,
    Value_8,
    Value_9,
    Value_10,
    Value_12 = 12,
    Value_14 = 14,
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
    Value_25,
    Value_26,
    Value_27,
    Value_29 = 29,
    Value_30
}
