if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (global.Phase != "Shop")
    {
        instance_destroy();
        exit;
    }
    if (obj_Dice_tray.Create_cover == 0)
    {
        instance_destroy();
        exit;
    }
    if (obj_Cursor.Holding != "Cat" && obj_Cursor.Holding != "Item")
    {
        instance_destroy();
        exit;
    }
}
else if (global.Game_Pause == 1)
{
}
