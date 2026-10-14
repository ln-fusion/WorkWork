function scr_Font_adjust()
{
    switch (global.lang_file)
    {
        case "lang_English.txt":
            if (global.screen_multiplier == 2)
            {
                global.font_norm1 = font_quantico12;
                global.font_norm2 = font_quantico14;
                global.font_big1 = font_quantico18;
                global.font_big2 = font_quantico22;
            }
            else if (global.screen_multiplier == 3)
            {
                global.font_norm1 = font_quantico18;
                global.font_norm2 = font_quantico22;
                global.font_big1 = font_quantico25;
                global.font_big2 = font_quantico28;
            }
            else if (global.screen_multiplier == 4)
            {
                global.font_norm1 = font_quantico25;
                global.font_norm2 = font_quantico28;
                global.font_big1 = font_quantico31;
                global.font_big2 = font_quantico34;
            }
            else
            {
                global.font_norm1 = font_quantico34;
                global.font_norm2 = font_quantico37;
                global.font_big1 = font_quantico40;
                global.font_big2 = font_quantico44;
            }
            draw_set_font(global.font_big1);
            break;
        case "lang_ChineseS.txt":
            if (global.screen_multiplier == 2)
            {
                global.font_norm1 = font_NotoCJK_12;
                global.font_norm2 = font_NotoCJK_14;
                global.font_big1 = font_NotoCJK_18;
                global.font_big2 = font_NotoCJK_22;
            }
            else if (global.screen_multiplier == 3)
            {
                global.font_norm1 = font_NotoCJK_18;
                global.font_norm2 = font_NotoCJK_22;
                global.font_big1 = font_NotoCJK_25;
                global.font_big2 = font_NotoCJK_28;
            }
            else if (global.screen_multiplier == 4)
            {
                global.font_norm1 = font_NotoCJK_25;
                global.font_norm2 = font_NotoCJK_28;
                global.font_big1 = font_NotoCJK_31;
                global.font_big2 = font_NotoCJK_34;
            }
            else
            {
                global.font_norm1 = font_NotoCJK_34;
                global.font_norm2 = font_NotoCJK_37;
                global.font_big1 = font_NotoCJK_40;
                global.font_big2 = font_NotoCJK_44;
            }
            draw_set_font(global.font_big1);
            break;
        case "lang_ChineseT.txt":
            if (global.screen_multiplier == 2)
            {
                global.font_norm1 = font_NotoCJK_12;
                global.font_norm2 = font_NotoCJK_14;
                global.font_big1 = font_NotoCJK_18;
                global.font_big2 = font_NotoCJK_22;
            }
            else if (global.screen_multiplier == 3)
            {
                global.font_norm1 = font_NotoCJK_18;
                global.font_norm2 = font_NotoCJK_22;
                global.font_big1 = font_NotoCJK_25;
                global.font_big2 = font_NotoCJK_28;
            }
            else if (global.screen_multiplier == 4)
            {
                global.font_norm1 = font_NotoCJK_25;
                global.font_norm2 = font_NotoCJK_28;
                global.font_big1 = font_NotoCJK_31;
                global.font_big2 = font_NotoCJK_34;
            }
            else
            {
                global.font_norm1 = font_NotoCJK_34;
                global.font_norm2 = font_NotoCJK_37;
                global.font_big1 = font_NotoCJK_40;
                global.font_big2 = font_NotoCJK_44;
            }
            draw_set_font(global.font_big1);
            break;
    }
}
