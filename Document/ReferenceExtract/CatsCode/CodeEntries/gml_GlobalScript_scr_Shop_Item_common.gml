function scr_Shop_Item_common(arg0)
{
    var var_Commonlist = ds_list_create();
    ds_list_add(var_Commonlist, UnknownEnum.Value_1000, UnknownEnum.Value_1001, UnknownEnum.Value_1003, UnknownEnum.Value_1004, UnknownEnum.Value_1006, UnknownEnum.Value_1007, UnknownEnum.Value_1008, UnknownEnum.Value_1009, UnknownEnum.Value_1010, UnknownEnum.Value_1011, UnknownEnum.Value_1012, UnknownEnum.Value_1013, UnknownEnum.Value_1014, UnknownEnum.Value_1017, UnknownEnum.Value_1018, UnknownEnum.Value_1019, UnknownEnum.Value_1020, UnknownEnum.Value_1021, UnknownEnum.Value_1022, UnknownEnum.Value_1100, UnknownEnum.Value_1101, UnknownEnum.Value_1102, UnknownEnum.Value_1103, UnknownEnum.Value_1104, UnknownEnum.Value_1105, UnknownEnum.Value_1106, UnknownEnum.Value_1107, UnknownEnum.Value_1108, UnknownEnum.Value_1109, UnknownEnum.Value_1110, UnknownEnum.Value_1111, UnknownEnum.Value_1112, UnknownEnum.Value_1113, UnknownEnum.Value_1114, UnknownEnum.Value_1115, UnknownEnum.Value_1116, UnknownEnum.Value_1117);
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
    Value_1000 = 1000,
    Value_1001,
    Value_1003 = 1003,
    Value_1004,
    Value_1006 = 1006,
    Value_1007,
    Value_1008,
    Value_1009,
    Value_1010,
    Value_1011,
    Value_1012,
    Value_1013,
    Value_1014,
    Value_1017 = 1017,
    Value_1018,
    Value_1019,
    Value_1020,
    Value_1021,
    Value_1022,
    Value_1100 = 1100,
    Value_1101,
    Value_1102,
    Value_1103,
    Value_1104,
    Value_1105,
    Value_1106,
    Value_1107,
    Value_1108,
    Value_1109,
    Value_1110,
    Value_1111,
    Value_1112,
    Value_1113,
    Value_1114,
    Value_1115,
    Value_1116,
    Value_1117
}
