draw_sprite_ext(spr_UI_Infobar, 0, 5, 10, 1, 1, 0, -1, 1);
draw_sprite_ext(scoreboard_sprite, scoreboard_subimg, 308, 50, scoreboard_scale, scoreboard_scale, 0, -1, 1);
draw_sprite_ext(spr_UI_Centerboard, centerboard_subimg, 160, 10, 1, 1, 0, -1, 1);
if (infobar_win > 0)
{
    draw_sprite_ext(spr_UI_Centerboard_Win, win_subimg, 162, 10, 1, 1, 0, -1, 1);
}
