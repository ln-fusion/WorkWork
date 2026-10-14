function scr_Save_shop()
{
    var var_ShopData = 
    {
        Shop_cat0: Shop_cat[0],
        Shop_cat1: Shop_cat[1],
        Shop_item0: Shop_item[0],
        Shop_item1: Shop_item[1],
        Shop_item2: Shop_item[2],
        Reroll_cost: Reroll_cost,
        Ticket_refresh: Ticket_refresh
    };
    var var_string = json_stringify(var_ShopData);
    var _buffer = buffer_create(string_byte_length(var_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, var_string);
    buffer_save(_buffer, "Save_ShopData.sav");
    buffer_delete(_buffer);
}
