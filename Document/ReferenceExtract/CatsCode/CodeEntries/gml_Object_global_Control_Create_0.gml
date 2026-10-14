global.lang_file = "lang_English.txt";
global.font_dice = font_add_sprite_ext(spr_Dice_font, "0123456789", true, 1);
global.font_white_small = font_add_sprite_ext(spr_font_dicesmall, "0123456789", true, 1);
global.font_score_small = font_add_sprite_ext(spr_font_scoresmall, "0123456789.+-x$R", true, 1);
global.font_score_big = font_add_sprite_ext(spr_font_scorebig, "0123456789.,-", true, 3);
global.font_digital = font_add_sprite_ext(spr_font_digital, "0123456789-", false, 2);
global.font_norm1 = font_quantico12;
global.font_norm2 = font_quantico14;
global.font_big1 = font_quantico18;
global.font_big2 = font_quantico22;
global.Fullscreen = 0;
global.Screen_width = 1280;
global.Screen_height = 720;
global.screen_multiplier = global.Screen_height div 360;
global.Camera_width = floor(global.Screen_width / global.screen_multiplier);
global.Camera_height = floor(global.Screen_height / global.screen_multiplier);
global.Camera_offset_x = floor((global.Camera_width - 640) / 2);
global.Camera_offset_y = floor((global.Camera_height - 360) / 2);
global.Camera_x = 0;
global.Camera_y = 0;
global.Camera = camera_create_view(0, 0, global.Camera_width, global.Camera_height, 0, -1, -1, -1, 304, 164);
audio_group_load(audiogroup_SFX);
audio_group_load(audiogroup_Music);
global.Volume_Master = 1;
global.Volume_SFX = 1;
global.Volume_Music = 1;
if (file_exists("Save_SystemData.sav"))
{
    var _buffer = buffer_load("Save_SystemData.sav");
    var var_string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    var var_SystemData = json_parse(var_string);
    if (struct_get(var_SystemData, "Volume_Master") != undefined)
    {
        global.Volume_Master = var_SystemData.Volume_Master;
        global.Volume_SFX = var_SystemData.Volume_SFX;
        global.Volume_Music = var_SystemData.Volume_Music;
        global.Fullscreen = var_SystemData.Fullscreen;
        if (global.Fullscreen == 1)
        {
            global.Screen_width = display_get_width();
            global.Screen_height = display_get_height();
            window_set_fullscreen(true);
        }
        else if (global.Fullscreen == 0.5)
        {
            global.Screen_width = display_get_width();
            global.Screen_height = display_get_height();
            window_set_showborder(false);
            alarm[0] = 16;
            global.Fullscreen = -1;
        }
        else
        {
            global.Screen_width = var_SystemData.Screen_width;
            global.Screen_height = var_SystemData.Screen_height;
        }
        global.screen_multiplier = global.Screen_height div 360;
        global.Camera_width = floor(global.Screen_width / global.screen_multiplier);
        global.Camera_height = floor(global.Screen_height / global.screen_multiplier);
        global.Camera_offset_x = floor((global.Camera_width - 640) / 2);
        global.Camera_offset_y = floor((global.Camera_height - 360) / 2);
        if (struct_get(var_SystemData, "lang_file") != undefined)
        {
            global.lang_file = var_SystemData.lang_file;
        }
    }
}
scr_Font_adjust();
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
global.Ctrl_SFX = global.Volume_Master * global.Volume_SFX;
global.Ctrl_Music = global.Volume_Master * global.Volume_Music;
audio_group_set_gain(audiogroup_Music, global.Ctrl_Music, 0);
Music_start = 0;
view_set_camera(0, global.Camera);
view_set_wport(0, global.Camera_width);
view_set_hport(0, global.Camera_height);
surface_resize(application_surface, global.Screen_width, global.Screen_height);
window_set_size(global.Screen_width, global.Screen_height);
camera_set_view_pos(global.Camera, -global.Camera_offset_x, -global.Camera_offset_y);
camera_set_view_size(global.Camera, global.Camera_width, global.Camera_height);
room_set_camera(room, 0, global.Camera);
global.deltaTime = 1;
global.Game_Pause = 0;
global.Freeze_frame = 0;
global.Scoring_spd = 0;
global.Scoring_spd_increase = 0.2;
global.Sparks_spd = 0;
Freeze_counter = 0;
Freeze_counterMax = 5;
Screenshot = 0;
global.Tut_Progress = 0;
global.Control = 0;
kEscape = 27;
kLmouse = 1;
kRmouse = 2;
kSpace = 32;
global.Escape = 0;
global.Lmouse_click = 0;
global.Lmouse_pressed = 0;
global.Rmouse_pressed = 0;
global.Space_pressed = 0;
global.One_pressed = 0;
global.Two_pressed = 0;
global.Three_pressed = 0;
global.Four_pressed = 0;
global.Five_pressed = 0;
global.Six_pressed = 0;
depth = layer_get_depth("UI") - 1;
instance_create_layer(x, y, "UI", obj_Menu_draw);
instance_create_layer(x, y, "UI", global_BG_draw);
global.Phase = 0;
if (file_exists("Save_MetaData.sav"))
{
    var _buffer = buffer_load("Save_MetaData.sav");
    var var_string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    var var_MetaData = json_parse(var_string);
    if (struct_get(var_MetaData, "Screenshot") != undefined)
    {
        Screenshot = var_MetaData.Screenshot;
    }
    if (struct_get(var_MetaData, "Tutorial") != undefined)
    {
        global.Tut_Progress = var_MetaData.Tutorial;
    }
}
