with (obj_Menu_titlescreen)
{
    if (Interactable == 1)
    {
        draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    }
}
with (obj_Menu_keybind)
{
    draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text_key);
}
with (obj_Menu_language)
{
    draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text_window);
}
with (obj_Menu_language_dropdown)
{
    draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
    switch (Language)
    {
        case "English":
            if (global.screen_multiplier == 2)
            {
                draw_set_font(font_quantico18);
            }
            else if (global.screen_multiplier == 3)
            {
                draw_set_font(font_quantico25);
            }
            else if (global.screen_multiplier == 4)
            {
                draw_set_font(font_quantico31);
            }
            else
            {
                draw_set_font(font_quantico40);
            }
            break;
        case "ChineseS":
            if (global.screen_multiplier == 2)
            {
                draw_set_font(font_NotoCJK_18);
            }
            else if (global.screen_multiplier == 3)
            {
                draw_set_font(font_NotoCJK_25);
            }
            else if (global.screen_multiplier == 4)
            {
                draw_set_font(font_NotoCJK_31);
            }
            else
            {
                draw_set_font(font_NotoCJK_40);
            }
            break;
        case "ChineseT":
            if (global.screen_multiplier == 2)
            {
                draw_set_font(font_NotoCJK_18);
            }
            else if (global.screen_multiplier == 3)
            {
                draw_set_font(font_NotoCJK_25);
            }
            else if (global.screen_multiplier == 4)
            {
                draw_set_font(font_NotoCJK_31);
            }
            else
            {
                draw_set_font(font_NotoCJK_40);
            }
            break;
    }
    draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text_window);
    draw_set_font(global.font_big1);
}
with (obj_Menu_resolution)
{
    draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text_window);
}
with (obj_Menu_resolution_dropdown)
{
    draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
    draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text_window);
}
draw_set_halign(fa_left);
with (obj_Menu_borderless)
{
    draw_text((x + 32 + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
draw_set_halign(fa_right);
with (obj_Menu_fullscreen)
{
    draw_text(((x - 8) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
with (obj_Menu_resolution)
{
    draw_text(((x - 8 - 54) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
with (obj_Menu_language)
{
    draw_text(((x - 8 - 54) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
with (obj_Menu_keybind)
{
    draw_text(((x - 8 - 48) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
with (obj_Menu_vol_master)
{
    draw_text(((x - 10) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
with (obj_Menu_vol_sfx)
{
    draw_text(((x - 10) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
with (obj_Menu_vol_music)
{
    draw_text(((x - 10) + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
}
draw_set_halign(fa_center);
