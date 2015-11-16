-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1
--DEBUG_FPS = true

-- design resolution
CONFIG_SCREEN_WIDTH  = 1024
CONFIG_SCREEN_HEIGHT = 768

-- CONFIG_SCREEN_WIDTH  = 1136
-- CONFIG_SCREEN_HEIGHT = 640

CONFIG_SCREEN_ORIENTATION = "landscape"
-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"

--director = CCDirector:sharedDirector();
--print(director);
--director:setOpenGLView(CCEGLView:sharedOpenGLView());
--[[
CONFIG_AUTOSCALE_CALLBACK = function(w, h, deviceModel)
    print("run here");
    print(w)
    print(h)
    if (w == 768 and h == 1024)
        or (w == 1536 and h == 2048) then
            -- iPad
            CONFIG_SCREEN_WIDTH = 768
            CONFIG_SCREEN_HEIGHT = 1024
            return 1.0, 1.0
    end
end
]]--
-- sounds
GAME_SFX = {
    tapButton      = "sound/TapButtonSound.mp3",
    backButton     = "sound/BackButtonSound.mp3",
    flipCoin       = "sound/ConFlipSound.mp3",
    levelCompleted = "sound/LevelWinSound.mp3",
}

    
    
MUSIC = {
    backgroundMusic = "sound/newdali.mp3",
}

--start res:
START_IMAGE_FILENAME = "start/shouye.png"
START_DATA_FILENAME = "start/shouye.plist"
START_BG_IMAGE_FILENAME = "start/bj.png"
START_BG_DATA_FILENAME = "start/bj.plist";

JIESHAO_FILENAME = "start/jieshao.png";
JIESHAO_DATA_FILENAME = "start/jieshao.plist";

GAME_PLAY_DATA_FILENAME = "youxi.plist";
GAME_PLAY_IMAGE_FILENAME = "youxi.png";

--c12 res:
C12_TEXTURE_DATA_FILENAME  = "c12/c123.plist"
C12_TEXTURE_IMAGE_FILENAME = "c12/c123.png"

C21_TEXTURE_DATA_FILENAME = "c21/c212.plist"
C21_TEXTURE_IMAGE_FILENAME = "c21/c212.png"

C23_TEXTURE_DATA_FILENAME = "c23/c23.plist"
C23_TEXTURE_IMAGE_FILENAME = "c23/c23.png"

C31_TEXTURE_DATA_FILENAME = "c31/c31.plist"
C31_TEXTURE_IMAGE_FILENAME = "c31/c31.png"

C32_TEXTURE_DATA_FILENAME = "c32/c32.plist"
C32_TEXTURE_IMAGE_FILENAME = "c32/c32.png"

C33_TEXTURE_DATA_FILENAME = "c33/c33.plist"
C33_TEXTURE_IMAGE_FILENAME = "c33/c33.png"

C41_TEXTURE_DATA_FILENAME = "c41/c41.plist"
C41_TEXTURE_IMAGE_FILENAME = "c41/c41.png"

C43_TEXTURE_DATA_FILENAME = "c43/c43.plist"
C43_TEXTURE_IMAGE_FILENAME = "c43/c43.png"

COMMON_ZIMU_DATA_FILENAME = "common/zimu.plist"
COMMON_ZIMU_IMAGE_FILENAME = "common/zimu.png"

JIESHU_DATA_FILENAME = "jieju/jieju.plist"
JIESHU_IMAGE_FILENAME = "jieju/jieju.png" 

DBFILE = "db/huiguniang.sqlite"

FONTFILE = "font/DFGB_Y7.ttf";


-- 于晓华
-- UIAlertView
UIALERTVIEW_TEXTURE_PNG         = "UIAlertView/AlertView.png"
UIALERTVIEW_TEXTURE_PLIST       = "UIAlertView/AlertView.plist"

-- MainMenu
MAIN_MENU_TEXTURE_PNG           = "MainMenu/MainMenuTexture.png"
MAIN_MENU_TEXTURE_PLIST         = "MainMenu/MainMenuTexture.plist"

-- 章节选择视图
CHAPTER_SELECT_TEXTURE_PNG      = "ChapterSelect/ChapterSelectTexture.png"
CHAPTER_SELECT_TEXTURE_PLIST    = "ChapterSelect/ChapterSelectTexture.plist"

-- 购买提示
BUYING_TIPS_TEXTURE_PNG         = "SmallPanels/BuyingTipsTexture.png"
BUYING_TIPS_TEXTURE_PLIST       = "SmallPanels/BuyingTipsTexture.plist"

-- Public UI Menu
PUBLIC_UI_MENU_TEXTURE_PNG      = "PublicUIMenu/PublicUIMenu_Button.png"
PUBLIC_UI_MENU_TEXTURE_PLIST    = "PublicUIMenu/PublicUIMenu_Button.plist"

PUBLIC_UI_MENU_ANIMATION_PNG    = "PublicUIMenu/Animation/Envelope.png"
PUBLIC_UI_MENU_ANIMATION_PLIST  = "PublicUIMenu/Animation/Envelope.plist"
PUBLIC_UI_MENU_ANIMATION_XML    = "PublicUIMenu/Animation/Envelope.xml"

-- ******************************************************************************************