/*
===============================================================================
Fortunes of War Cataclysm Spawn - Overlay
===============================================================================
Author: ChadMasodin
Language: English
Release date: 10/12/2025
Description: This script is designed to display all enemy spawns as an overlay for Fortunes of War (Cataclysm).
===============================================================================
*/

#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

; ==============================================================================
; ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И НАСТРОЙКИ ПО УМОЛЧАНИЮ
; ==============================================================================
Global AppName := "FoW Cata Spawn ENG"
Global IniFile := "FoW_Settings.ini"

; Данные состояния
Global CurrentWave := 1
Global TotalWaves := 8
Global OverlayState := 1 ; 1 = Full, 0 = Mini
Global GuiWidth := 400

; Позиция окна (читается из INI)
Global MainX := ""
Global MainY := ""

; Цвета (HEX RGB)
Global cRed     := "FF4444"
Global cOrange  := "FFAA00" ; C, D, I
Global cYellow  := "FFFF00" ; E, F
Global cGreen   := "00FF00" ; G, H, J
Global cPurple  := "FF00FF"
Global cCyan    := "00FFFF"
Global cWhite   := "DDDDDD"
Global cBg      := "202020" ; Фон (прозрачный)
Global cHeader  := "000000" ; Фон заголовков
Global cDarkRed := "AA0000" ; Для крестика
Global cLabel   := "4488FF" ; Цвет названий настроек (Голубой)

; Переменные для горячих клавиш (значения по умолчанию)
Global Key_Next     := "Right"
Global Key_Prev     := "Left"
Global Key_Toggle   := "F1"
Global Key_Help     := "F2"
Global Key_Reload   := "^r"
Global Key_Exit     := "^Esc"
Global OverlayAlpha := 220 ; Прозрачность (50-255)

; Загрузка настроек при старте
LoadSettings()

; Инициализация данных волн
Global WavesData := []
InitWavesData()

; Запуск оверлея
CreateOverlay()
Return

; ==============================================================================
; ЛОГИКА ВОЛН И ДАННЫЕ
; ==============================================================================
InitWavesData() {
    ; Формат: [ЛевыйТекст, "", ПравыйТекст, ЦветПравый]
    ; Цвет левого текста вычисляется автоматически по буквам

    ; --- WAVE 1 ---
    WavesData[1] := [ ["A", "", "Skaven Inf", cWhite]
                    , ["D", "", "Chaos Inf", cWhite]
                    , ["EFH", "", "3x Ratling", cGreen]
                    , ["1. CONTINUE: 80s or < 8 enemies", cCyan]
                    , ["E", "", "Rat Ogre", cPurple]
                    , ["FI", "", "2x Hookrat", cGreen]
                    , ["*", , "Skaven Inf", cWhite]
                    , ["2. CONTINUE: 80s or < 8 enemies", cCyan]
                    , ["EH", "", "14x SV", cWhite]
                    , ["3. CONTINUE: 100s or < 3 enemies", cCyan] ]

    ; --- WAVE 2 ---
    WavesData[2] := [ ["A", "", "Chaos Inf", cWhite]
                    , ["1. CONTINUE: 80s or < 20 enemies", cCyan]
                    , ["D", "", "Chaos Inf / 7x Chaos Warrior", cWhite]
                    , ["ACIGH", "", "5x Globadier", cGreen]
                    , ["2. CONTINUE: 80s or < 2 enemies", cCyan]
                    , ["CE", "", "Chaos Inf", cWhite]
                    , ["3. CONTINUE: 80s or < 10 enemies", cCyan]
                    , ["K", "", "Chaos Spawn", cPurple]
                    , ["EFIGJ", "", "5x Hookrat", cGreen]
                    , ["AF", "", "Chaos Inf", cWhite]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["K", , "Globadier", cGreen]
                    , ["F", , "Warpfire", cGreen]
                    , ["4. CONTINUE: 120s or < 1 enemies", cCyan] ]

    ; --- WAVE 3 ---
    WavesData[3] := [ ["All", "", "12x Assassin", cGreen]
                    , ["IFH", "", "3x Globadier", cGreen]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["1. CONTINUE: 80s or < 4 enemies", cCyan]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["2. CONTINUE: 80s or < 12 enemies", cCyan]
                    , ["ABFG", "", "24x SV", cWhite]
                    , ["3. CONTINUE: 80s or < 10 enemies", cCyan]
                    , ["A", "", "Chaos Inf", cWhite]
                    , ["FECG", "", "4x Blightstormer", cGreen]
                    , ["FK", "", "2x Leech", cGreen]
                    , ["4. CONTINUE: 80s or < 8 enemies", cCyan]
                    , ["A", "", "12x Berzerker", cWhite]
                    , ["D", "", "Chaos Inf / 2x Mauler", cWhite]
                    , ["5. CONTINUE: 120s or < 3 enemies", cCyan] ]

    ; --- WAVE 4 ---
    WavesData[4] := [ ["ACDF", "", "Chaos Inf / 12x Mauler", cWhite]
                    , ["EF", "", "2x Ratling", cGreen]
                    , ["1. CONTINUE: 80s or < 20 enemies", cCyan]
                    , ["GC", "", "14x Chaos Warrior", cWhite]
                    , ["GJIABK", "", "6x Leech", cGreen]
                    , ["2. CONTINUE: 80s or < 5 enemies", cCyan]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["CIEFHJ", "", "6x Ratling", cGreen]
                    , ["3. CONTINUE: 80s or < 6 enemies", cCyan]
                    , ["EH", "", "10x SV / 8x Shield SV", cWhite]
                    , ["BI", "", "2x Hookrat", cGreen]
                    , ["F", "", "Warpfire", cGreen]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["4. CONTINUE: 100s or < 1 enemies", cCyan] ]

    ; --- WAVE 5 ---
    WavesData[5] := [ ["A", "", "Chaos Inf", cWhite]
                    , ["ABCDIF", "", "6x Warpfire", cGreen]
                    , ["EG", "", "20x Plague Monk", cWhite]
                    , ["1. CONTINUE: 80s or < 8 enemies", cCyan]
                    , ["J", "", "Stormfiend", cPurple]
                    , ["JHGF", "", "4x Globadier", cGreen]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["2. CONTINUE: 80s or < 5 enemies", cCyan]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["All", "", "8x Hookrat", cGreen]
                    , ["3. CONTINUE: 80s or < 5 enemies", cCyan]
                    , ["A", "", "Skaven Inf", cWhite]
                    , ["F", "", "10x SV", cWhite]
                    , ["4. CONTINUE: 160s or < 1 enemies", cCyan] ]

    ; --- WAVE 6 ---
    WavesData[6] := [ ["*", "", "Skaven Inf", cWhite]
                    , ["GHEFCB", "", "24x Plague Monk", cWhite]
                    , ["1. CONTINUE: 100s or < 8 enemies", cCyan]
                    , ["GC", "", "22x SV / 10x Shield SV", cWhite]
                    , ["GHJF", "", "4x Globadier", cGreen]
                    , ["2. CONTINUE: 80s or < 5 enemies", cCyan]
                    , ["EH", "", "Skaven Inf", cWhite]
                    , ["AKJC", "", "4x Assassin", cGreen]
                    , ["3. CONTINUE: 80s or < 3 enemies", cCyan]
                    , ["BF", "", "Chaos Inf / 14x Mauler", cWhite]
                    , ["All", "", "8x Ratling", cGreen]
                    , ["CJ", "", "2x Leech", cGreen]
                    , ["4. CONTINUE: 80s or < 10 enemies", cCyan]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["5. CONTINUE: 120s or < 3 enemies", cCyan] ]

    ; --- WAVE 7 ---
    WavesData[7] := [ ["A", "", "Troll", cPurple]
                    , ["AD", "", "Skaven Inf / 6x SV", cWhite]
                    , ["HJ", "", "2x Hookrat", cGreen]
                    , ["FG", "", "2x Leech", cGreen]
                    , ["1. CONTINUE: 80s or < 10 enemies", cCyan]
                    , ["IF", "", "2x Blightstormer", cGreen]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["2. CONTINUE: 80s or < 10 enemies", cCyan]
                    , ["HE", "", "20x Plague Monk", cWhite]
                    , ["3. CONTINUE: 80s or < 5 enemies", cCyan]
                    , ["AD", "", "Skaven Inf / 16x SV", cWhite]
                    , ["GJHFE", "", "6x Globadier", cGreen]
                    , ["4. CONTINUE: 80s or < 2 enemies", cCyan]
                    , ["HE", "", "24x Chaos Warrior / 2x Mauler", cWhite]
                    , ["GEFCIB", "", "6x Blightstormer", cGreen]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["5. CONTINUE: 180s or < 2 enemies", cCyan] ]

    ; --- WAVE 8 ---
    WavesData[8] := [ ["G", "", "Troll", cPurple]
                    , ["D", "", "Rat Ogre", cPurple]
                    , ["DA", "", "6x CW / Chaos Inf / 4x Mauler", cWhite]
                    , ["1. CONTINUE: 120s or < 6 enemies", cCyan]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["DIE", "", "3x Assassin", cGreen]
                    , ["2. CONTINUE: 120s or < 6 enemies", cCyan]
                    , ["FH", "", "16x Berzerker / 8x Mauler", cWhite]
                    , ["FH", "", "Chaos Inf", cWhite]
                    , ["FEI", "", "3x Hookrat", cGreen]
                    , ["*", "", "Skaven Inf", cWhite]
                    , ["3. CONTINUE: 160s or < 6 enemies", cCyan]
                    , ["A", "", "3x CW / Chaos Inf / 2x Mauler", cWhite]
                    , ["HGEF", "", "4x Globadier", cGreen]
                    , ["4. CONTINUE: 160s or < 6 enemies", cCyan]
                    , ["A", "", "Rat Ogre", cPurple]
                    , ["B", "", "Stormfiend", cPurple]
                    , ["KH", "", "2x Hookrat", cGreen]
                    , ["HJF", "", "3x Ratling", cGreen]
                    , ["GC", "", "16x SV / 8x Shield SV", cWhite]
                    , ["5. CONTINUE: 120s or < 6 enemies", cCyan] ]
    WavesData[8].Push(["*", "", "Skaven Inf", cWhite])
    WavesData[8].Push(["EH", "", "14x Plague Monk", cWhite])
    WavesData[8].Push(["AC", "", "2x Assassin", cGreen])
    WavesData[8].Push(["H", "", "Globadier", cGreen])
    WavesData[8].Push(["F", "", "Ratling", cGreen])
    WavesData[8].Push(["6. CONTINUE: 160s or < 6 enemies", cCyan])
    WavesData[8].Push(["AD", "", "Chaos Inf / 12x Mauler", cWhite])
    WavesData[8].Push(["HF", "", "16x SV / 4x Shield SV", cWhite])
    WavesData[8].Push(["E", "", "5x Chaos Warrior", cWhite])
    WavesData[8].Push(["FADH", "", "4x Warpfire", cGreen])
    WavesData[8].Push(["FJ", "", "2x Blightstormer", cGreen])
    WavesData[8].Push(["FGK", "", "3x Leech", cGreen])
    WavesData[8].Push(["7. CONTINUE: 160s or < 10 enemies", cCyan])
    WavesData[8].Push(["All", "", "Chaos Inf", cWhite])
    WavesData[8].Push(["*", "", "Skaven Inf", cWhite])
    WavesData[8].Push(["8. CONTINUE: 160s or < 5 enemies", cCyan])
    WavesData[8].Push(["*", "", "Skaven Inf", cWhite])
    WavesData[8].Push(["AD", "", "10x Chaos Warrior", cWhite])
    WavesData[8].Push(["9. CONTINUE: 300s or < 1 enemies", cCyan])
}

; Получить цвет для конкретной буквы
GetCharColor(char) {
    if RegExMatch(char, "i)[ABK]")
        return cRed
    if RegExMatch(char, "i)[CDI]")
        return cOrange
    if RegExMatch(char, "i)[EF]")
        return cYellow
    if RegExMatch(char, "i)[GHJ]")
        return cGreen
    if RegExMatch(char, "i)[All]")
        return cRed

    return cYellow ; Дефолт
}

; ==============================================================================
; GUI ФУНКЦИИ
; ==============================================================================
CreateOverlay() {
    ; Сохраняем текущую позицию перед пересозданием, если окно существует
    IfWinExist, %AppName%
    {
        WinGetPos, curX, curY
        MainX := curX
        MainY := curY
    }

    Gui, Main:Destroy
    Gui, Main:+AlwaysOnTop -Caption +ToolWindow +Owner +LastFound +HwndhMainGui
    Gui, Main:Color, %cBg%

    ; Устанавливаем прозрачность
    WinSet, Transparent, %OverlayAlpha%

    ; Расчет позиции при первом запуске (если нет сохраненных данных)
    if (MainX == "" || MainY == "") {
        SysGet, Mon, MonitorWorkArea
        MainX := MonRight - GuiWidth - 20
        MainY := MonTop + 20
    }

    if (OverlayState == 1)
        DrawFullOverlay()
    else
        DrawMiniOverlay()

    Gui, Main:Show, x%MainX% y%MainY% w%GuiWidth% NoActivate, %AppName%
}

DrawFullOverlay() {
    ; --- HEADER (Увеличенная высота) ---
    HeaderH := 30
    Gui, Main:Add, Progress, x0 y0 w%GuiWidth% h%HeaderH% Background%cHeader% Disabled
    Gui, Main:Font, s12 w700, Segoe UI

    Gui, Main:Add, Text, x370 y3 w30 h25 cRed BackgroundTrans Center 0x200 gGuiClose, X

    ; Верхний текст заголовка
    Gui, Main:Add, Text, x0 y3 w%GuiWidth% h20 cWhite BackgroundTrans Center 0x200 gDragWindow, FoW Spawns Cataclysm

    ; Второй ряд хедера
    Gui, Main:Font, s9 w700
    ; Левая кнопка (Hide)
    Gui, Main:Add, Text, x5 y35 w100 h20 cff5757 BackgroundTrans 0x200 gToggleOverlay, Hide (%Key_Toggle%)
    ; Правая кнопка (Help)
    Gui, Main:Add, Text, x290 y35 w100 h20 cfffd57 BackgroundTrans Right 0x200 gShowHelp, Settings (%Key_Help%)
    ; Текущая волна
    Gui, Main:Font, s18 w700
    Gui, Main:Add, Text, x0 y35 w%GuiWidth% h20 cWhite BackgroundTrans Center 0x200 gDragWindow, WAVE %CurrentWave%

    ; --- BODY ---
    Gui, Main:Font, s11 w600, Consolas
    CurrentY := HeaderH + 40

    ThisWave := WavesData[CurrentWave]
    if (IsObject(ThisWave)) {
        Loop % ThisWave.MaxIndex() {
            Row := ThisWave[A_Index]
            LeftText := Row[1]
            RightText := Row[3]
            RightColor := Row[4]

            if (InStr(LeftText, "CONTINUE")) {
                ; Центрированный текст таймера/условия
                LeftColor := Row[2] ; Для таймера берем цвет из массива
                Gui, Main:Font, s9 w400
                Gui, Main:Add, Text, x10 y%CurrentY% w380 c%LeftColor% BackgroundTrans Center, %LeftText%
                Gui, Main:Font, s11 w600
                CurrentY += 20
            } else {
                ; Рендеринг разноцветных букв слева
                CharWidth := 10
                StartX := 10

                ; Парсим левую строку посимвольно для цвета
                Loop, Parse, LeftText
                {
                    CharColor := GetCharColor(A_LoopField)
                    if (A_Index == 1)
                        Gui, Main:Add, Text, x%StartX% y%CurrentY% w%CharWidth% c%CharColor% BackgroundTrans Right, %A_LoopField%
                    else
                        Gui, Main:Add, Text, x+0 yp w%CharWidth% c%CharColor% BackgroundTrans Right, %A_LoopField%
                }

                ; Правый текст
                if (RightText != "") {
                    Gui, Main:Add, Text, x120 y%CurrentY% w270 Left c%RightColor% BackgroundTrans, %RightText%
                }
                CurrentY += 22
            }
        }
    }

    CurrentY += 5

    ; --- FOOTER (Navigation) ---
    Gui, Main:Add, Progress, x0 y%CurrentY% w%GuiWidth% h24 Background%cBg% Disabled
    Gui, Main:Font, s12 w900, Segoe UI

    ; Стрелка влево
    Gui, Main:Add, Text, x0 y%CurrentY% w40 h24 cWhite BackgroundTrans Center 0x200 gPrevWave, <
    ; Счетчик
    Gui, Main:Font, s10 w600
    Gui, Main:Add, Text, x40 y%CurrentY% w320 h24 cWhite BackgroundTrans Center 0x200, %CurrentWave% / %TotalWaves%
    ; Стрелка вправо
    Gui, Main:Font, s12 w900
    Gui, Main:Add, Text, x360 y%CurrentY% w40 h24 cWhite BackgroundTrans Center 0x200 gNextWave, >

    CurrentY += 25

    ; Обрезаем высоту окна под контент
    Gui, Main:Show, h%CurrentY% NoActivate
}

DrawMiniOverlay() {
    HeaderH := 30
    Gui, Main:Add, Progress, x0 y0 w%GuiWidth% h%HeaderH% Background%cHeader% Disabled
    Gui, Main:Font, s12 w700, Segoe UI

    Gui, Main:Add, Text, x370 y3 w30 h25 cRed BackgroundTrans Center 0x200 gGuiClose, X

    ; Верхний текст заголовка
    Gui, Main:Add, Text, x0 y3 w%GuiWidth% h20 cWhite BackgroundTrans Center 0x200 gDragWindow, FoW Spawns Cataclysm

    ; Второй ряд хедера
    Gui, Main:Font, s10 w700, Segoe UI
    ; Левая кнопка (Hide)
    Gui, Main:Add, Text, x5 y32 w125 h20 c67ff57 BackgroundTrans 0x200 gToggleOverlay, Show (%Key_Toggle%)
    ; Правая кнопка (Help)
    Gui, Main:Add, Text, x260 y32 w125 h20 cYellow BackgroundTrans Right 0x200 gShowHelp, Settings (%Key_Help%)

    ; --- BODY ---
    Gui, Main:Font, s11 w600, Consolas
    CurrentY := HeaderH + 30

    ; Обрезаем высоту окна под контент
    Gui, Main:Show, h%CurrentY% NoActivate
}

DragWindow:
    PostMessage, 0xA1, 2
Return

; ==============================================================================
; НАВИГАЦИЯ И УПРАВЛЕНИЕ
; ==============================================================================
NextWave:
    if (CurrentWave < TotalWaves) {
        CurrentWave++
        CreateOverlay()
    }
Return

PrevWave:
    if (CurrentWave > 1) {
        CurrentWave--
        CreateOverlay()
    }
Return

ToggleOverlay:
    OverlayState := !OverlayState
    CreateOverlay()
Return

GuiClose:
    ExitApp
Return

; ==============================================================================
; ОКНО СПРАВКИ И НАСТРОЕК
; ==============================================================================
ShowHelp:
    ; Перед открытием настроек получаем текущую позицию, чтобы сохранить её при нажатии Save
    IfWinExist, %AppName%
        WinGetPos, MainX, MainY

    Gui, Help:New, +LabelHelpWin
    Gui, Help:Font, s10, Segoe UI

    ; Инфо
    Gui, Font, c666666 s11 Bold Q3, Segoe UI Black
    Gui, Help:Add, GroupBox, x10 y10 w330 h200 Center, INFO
    Gui, Font,
    Gui, Add, Picture, w90 h90 x25 y25, fow icon.png
    Gui, Help:Font, s10, Segoe UI
    Gui, Add, Link, xs+130 yp+10, Author: <a href="https://steamcommunity.com/id/ChadMasodin">ChadMasodin</a>
    Gui, Add, Text, xs+130 yp+25, Release date:  10/12/2025
    Gui, Add, Text, xs+130 yp+25, Update date:  10/12/2025
    Gui, Add, Link, xs+10 yp+40, This script is designed to display all enemy spawns,`nas an overlay for Fortunes of War (Cataclysm).`n`nMore information about it can be found in this <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3620892502">guide.</a>

    ; Настройки
    Gui, Font, c666666 s11 Bold Q3, Segoe UI Black
    Gui, Help:Add, GroupBox, x10 y220 w330 h370 Center, SETTINGS
    Gui, Font,
    Gui, Help:Font, s10, Segoe UI

    ; Функция для быстрого создания полей
    AddHotkeyControl("Next Wave", "hkNext", Key_Next, 260)
    AddHotkeyControl("Previous  Wave", "hkPrev", Key_Prev, 300)
    AddHotkeyControl("Toggle Overlay", "hkToggle", Key_Toggle, 340)
    AddHotkeyControl("Open Settings", "hkHelp", Key_Help, 380)
    AddHotkeyControl("Reload", "hkReload", Key_Reload, 420)
    AddHotkeyControl("Close Script", "hkExit", Key_Exit, 460)

    ; Слайдер прозрачности
    Gui, Help:Font, s11, Segoe UI
    Gui, Help:Add, Text, x30 y500 w100, Opacity:
    Gui, Help:Add, Slider, x100 y500 w210 vSlAlpha Range50-255 ToolTip, %OverlayAlpha%

    ; Кнопки
    Gui, Help:Add, Button, x40 y540 w110 h30 gSaveSettings, Save
    Gui, Help:Add, Button, x180 y540 w110 h30 gHelpWinClose, Cancel

    Gui, Help:Show, w350 h600, Readme
Return

AddHotkeyControl(Label, VarName, DefVal, YPos) {
    ; Устанавливаем жирный шрифт и цвет для названия настройки
    Gui, Help:Font, s11 w700 c%cLabel%
    Gui, Help:Add, Text, x30 y%YPos% w170, %Label%:
    ; Возвращаем обычный шрифт для поля ввода
    Gui, Help:Font, s10 w400 cDefault
    Gui, Help:Add, Hotkey, x180 yp-3 w140 v%VarName%, %DefVal%
}

SaveSettings:
    Gui, Help:Submit

    ; Обновляем глобальные переменные
    Key_Next := hkNext
    Key_Prev := hkPrev
    Key_Toggle := hkToggle
    Key_Help := hkHelp
    Key_Reload := hkReload
    Key_Exit := hkExit
    OverlayAlpha := SlAlpha

    ; Сохраняем в INI
    IniWrite, %Key_Next%, %IniFile%, Hotkeys, Next
    IniWrite, %Key_Prev%, %IniFile%, Hotkeys, Prev
    IniWrite, %Key_Toggle%, %IniFile%, Hotkeys, Toggle
    IniWrite, %Key_Help%, %IniFile%, Hotkeys, Help
    IniWrite, %Key_Reload%, %IniFile%, Hotkeys, Reload
    IniWrite, %Key_Exit%, %IniFile%, Hotkeys, Exit
    IniWrite, %OverlayAlpha%, %IniFile%, Settings, Alpha

    ; Сохраняем позицию окна, если она была захвачена
    if (MainX != "" && MainY != "") {
        IniWrite, %MainX%, %IniFile%, Position, X
        IniWrite, %MainY%, %IniFile%, Position, Y
    }

    ApplyHotkeys()
    CreateOverlay() ; Перерисовать для применения прозрачности
    Gui, Help:Destroy
Return

HelpWinClose:
    Gui, Help:Destroy
Return

; ==============================================================================
; ФУНКЦИИ ГОРЯЧИХ КЛАВИШ И INI
; ==============================================================================
LoadSettings() {
    IfExist, %IniFile%
    {
        IniRead, Key_Next, %IniFile%, Hotkeys, Next, Right
        IniRead, Key_Prev, %IniFile%, Hotkeys, Prev, Left
        IniRead, Key_Toggle, %IniFile%, Hotkeys, Toggle, F1
        IniRead, Key_Help, %IniFile%, Hotkeys, Help, F2
        IniRead, Key_Reload, %IniFile%, Hotkeys, Reload, ^r
        IniRead, Key_Exit, %IniFile%, Hotkeys, Exit, ^Esc
        IniRead, OverlayAlpha, %IniFile%, Settings, Alpha, 220

        ; Читаем позицию
        IniRead, MainX, %IniFile%, Position, X, %A_Space%
        IniRead, MainY, %IniFile%, Position, Y, %A_Space%
    }
    ApplyHotkeys()
}

ApplyHotkeys() {
    ; ИСПОЛЬЗУЕМ "~" ЧТОБЫ КЛАВИШИ РАБОТАЛИ В ДРУГИХ ОКНАХ
    Hotkey, ~%Key_Next%, NextWave, On
    Hotkey, ~%Key_Prev%, PrevWave, On
    Hotkey, ~%Key_Toggle%, ToggleOverlay, On
    Hotkey, ~%Key_Help%, ShowHelp, On
    Hotkey, ~%Key_Reload%, ReloadApp, On
    Hotkey, ~%Key_Exit%, ExitApp, On
}

ReloadApp:
    Reload
Return

ExitApp:
    ExitApp
Return