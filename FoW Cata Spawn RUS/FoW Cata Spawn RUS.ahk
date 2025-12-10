/*
===============================================================================
Fortunes of War Cataclysm Spawn - Overlay
===============================================================================
Author: ChadMasodin
Language: Russian
Release date: 10/12/2025
Description: Этот скрипт предназначен для отображения всего спавна врагов в виде оверлея для Fortunes of War (Cataclysm).
===============================================================================
*/

#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

; ==============================================================================
; ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И НАСТРОЙКИ ПО УМОЛЧАНИЮ
; ==============================================================================
Global AppName := "FoW Cata Spawn RUS"
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
; ЛОГИКА ВОЛН И ДАННЫЕ (ПЕРЕВОД)
; ==============================================================================
InitWavesData() {
    ; Формат: [ЛевыйТекст, Цвет(если пусто-авто), ПравыйТекст, ЦветПравый]

    ; --- ВОЛНА 1 ---
    WavesData[1] := [ ["A", "", "Орда скавенов", cWhite]
                    , ["D", "", "Орда хаоса", cWhite]
                    , ["EFH", "", "3x Ратлинга", cGreen]
                    , ["1. ДАЛЕЕ: 80с или < 8 врагов", cCyan]
                    , ["E", "", "Крысоогр", cPurple]
                    , ["FI", "", "2x Пака", cGreen]
                    , ["*", , "Орда скавенов", cWhite]
                    , ["2. ДАЛЕЕ: 80с или < 8 врагов", cCyan]
                    , ["EH", "", "14x Штормов", cWhite]
                    , ["3. ДАЛЕЕ: 100с или < 3 врагов", cCyan] ]

    ; --- ВОЛНА 2 ---
    WavesData[2] := [ ["A", "", "Орда хаоса", cWhite]
                    , ["1. ДАЛЕЕ: 80с или < 20 врагов", cCyan]
                    , ["D", "", "Орда хаоса / 7x Воинов Хаоса", cWhite]
                    , ["ACIGH", "", "5x Газов", cGreen]
                    , ["2. ДАЛЕЕ: 80с или < 2 врагов", cCyan]
                    , ["CE", "", "Орда хаоса", cWhite]
                    , ["3. ДАЛЕЕ: 80с или < 10 врагов", cCyan]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["K", "", "Отродье Хаоса", cPurple]
                    , ["AF", "", "Орда хаоса", cWhite]
                    , ["EFIGJ", "", "5x Паков", cGreen]
                    , ["K", , "Газ", cGreen]
                    , ["F", , "Огнемет", cGreen]
                    , ["4. ДАЛЕЕ: 120с или < 1 врагов", cCyan] ]

    ; --- ВОЛНА 3 ---
    WavesData[3] := [ ["*", "", "Орда скавенов", cWhite]
                    , ["All", "", "12x Ассасинов", cGreen]
                    , ["FHI", "", "3x Газа", cGreen]
                    , ["1. ДАЛЕЕ: 80с или < 4 врагов", cCyan]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["2. ДАЛЕЕ: 80с или < 12 врагов", cCyan]
                    , ["ABFG", "", "24x Шторма", cWhite]
                    , ["3. ДАЛЕЕ: 80с или < 10 врагов", cCyan]
                    , ["A", "", "Орда хаоса", cWhite]
                    , ["FECG", "", "4x Блайта", cGreen]
                    , ["FK", "", "2x Лича", cGreen]
                    , ["4. ДАЛЕЕ: 80с или < 8 врагов", cCyan]
                    , ["A", "", "12x Берсерков", cWhite]
                    , ["D", "", "Орда хаоса / 2x Маулера", cWhite]
                    , ["5. ДАЛЕЕ: 120с или < 3 врагов", cCyan] ]

    ; --- ВОЛНА 4 ---
    WavesData[4] := [ ["ACDF", "", "Орда хаоса / 12x Маулеров", cWhite]
                    , ["EF", "", "2x Ратлинга", cGreen]
                    , ["1. ДАЛЕЕ: 80с или < 20 врагов", cCyan]
                    , ["GC", "", "14x Воинов Хаоса", cWhite]
                    , ["GJIABK", "", "6x Личей", cGreen]
                    , ["2. ДАЛЕЕ: 80с или < 5 врагов", cCyan]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["CIEFHJ", "", "6x Ратлингов", cGreen]
                    , ["3. ДАЛЕЕ: 80с или < 6 врагов", cCyan]
                    , ["EH", "", "10x Штормов / 8x Со щитами", cWhite]
                    , ["BI", "", "2x Пака", cGreen]
                    , ["F", "", "Огнемет", cGreen]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["4. ДАЛЕЕ: 100с или < 1 врагов", cCyan] ]

    ; --- ВОЛНА 5 ---
    WavesData[5] := [ ["A", "", "Орда хаоса", cWhite]
                    , ["ABCDIF", "", "6x Огнеметов", cGreen]
                    , ["EG", "", "20x Монок", cWhite]
                    , ["1. ДАЛЕЕ: 80с или < 8 врагов", cCyan]
                    , ["J", "", "Штормфинд", cPurple]
                    , ["JHGF", "", "4x Газа", cGreen]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["2. ДАЛЕЕ: 80с или < 5 врагов", cCyan]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["All", "", "8x Паков", cGreen]
                    , ["3. ДАЛЕЕ: 80с или < 5 врагов", cCyan]
                    , ["A", "", "Орда скавенов", cWhite]
                    , ["F", "", "10x Штормов", cWhite]
                    , ["4. ДАЛЕЕ: 160с или < 1 врагов", cCyan] ]

    ; --- ВОЛНА 6 ---
    WavesData[6] := [ ["*", "", "Орда скавенов", cWhite]
                    , ["GHEFCB", "", "24x Монок", cWhite]
                    , ["1. ДАЛЕЕ: 100с или < 8 врагов", cCyan]
                    , ["GC", "", "22x Шторма / 10x Со щитами", cWhite]
                    , ["GHJF", "", "4x Газа", cGreen]
                    , ["2. ДАЛЕЕ: 80с или < 5 врагов", cCyan]
                    , ["EH", "", "Орда скавенов", cWhite]
                    , ["AKJC", "", "4x Ассасина", cGreen]
                    , ["3. ДАЛЕЕ: 80с или < 3 врагов", cCyan]
                    , ["BF", "", "Орда хаоса / 14x Маулеров", cWhite]
                    , ["All", "", "8x Ратлингов", cGreen]
                    , ["CJ", "", "2x Лича", cGreen]
                    , ["4. ДАЛЕЕ: 80с или < 10 врагов", cCyan]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["5. ДАЛЕЕ: 120с или < 3 врагов", cCyan] ]

    ; --- ВОЛНА 7 ---
    WavesData[7] := [ ["A", "", "Тролль", cPurple]
                    , ["AD", "", "Орда скавенов / 6x Штормов", cWhite]
                    , ["HJ", "", "2x Пака", cGreen]
                    , ["FG", "", "2x Лича", cGreen]
                    , ["1. ДАЛЕЕ: 80с или < 10 врагов", cCyan]
                    , ["IF", "", "2x Блайта", cGreen]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["2. ДАЛЕЕ: 80с или < 10 врагов", cCyan]
                    , ["HE", "", "20x Монок", cWhite]
                    , ["3. ДАЛЕЕ: 80с или < 5 врагов", cCyan]
                    , ["AD", "", "Орда скавенов / 16x Штормов", cWhite]
                    , ["GJHFE", "", "6x Газов", cGreen]
                    , ["4. ДАЛЕЕ: 80с или < 2 врагов", cCyan]
                    , ["HE", "", "24x Воинов Хаоса / 2x Маулера", cWhite]
                    , ["GEFCIB", "", "6x Блайтов", cGreen]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["5. ДАЛЕЕ: 180с или < 2 врагов", cCyan] ]

    ; --- ВОЛНА 8 ---
    WavesData[8] := [ ["G", "", "Тролль", cPurple]
                    , ["D", "", "Крысоогр", cPurple]
                    , ["DA", "", "6x ВХ / ОрдаХ / 4x Маулера", cWhite]
                    , ["1. ДАЛЕЕ: 120с или < 6 врагов", cCyan]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["DIE", "", "3x Ассасина", cGreen]
                    , ["2. ДАЛЕЕ: 120с или < 6 врагов", cCyan]
                    , ["FH", "", "16x Берсерков / 8x Маулеров", cWhite]
                    , ["FH", "", "Орда хаоса", cWhite]
                    , ["FEI", "", "3x Пака", cGreen]
                    , ["*", "", "Орда скавенов", cWhite]
                    , ["3. ДАЛЕЕ: 160с или < 6 врагов", cCyan]
                    , ["A", "", "3x ВХ / ОрдаХ / 2x Маулера", cWhite]
                    , ["HGEF", "", "4x Газа", cGreen]
                    , ["4. ДАЛЕЕ: 160с или < 6 врагов", cCyan]
                    , ["A", "", "Крысоогр", cPurple]
                    , ["B", "", "Штормфинд", cPurple]
                    , ["KH", "", "2x Пака", cGreen]
                    , ["HJF", "", "3x Ратлинга", cGreen]
                    , ["GC", "", "16x Штормов / 8x Со щитами", cWhite]
                    , ["5. ДАЛЕЕ: 120с или < 6 врагов", cCyan] ]
    WavesData[8].Push(["*", "", "Орда скавенов", cWhite])
    WavesData[8].Push(["EH", "", "14x Монок", cWhite])
    WavesData[8].Push(["AC", "", "2x Ассасина", cGreen])
    WavesData[8].Push(["H", "", "Газ", cGreen])
    WavesData[8].Push(["F", "", "Ратлинг", cGreen])
    WavesData[8].Push(["6. ДАЛЕЕ: 160с или < 6 врагов", cCyan])
    WavesData[8].Push(["AD", "", "Орда хаоса / 12x Маулеров", cWhite])
    WavesData[8].Push(["HF", "", "16x Штормов / 4x Со щитами", cWhite])
    WavesData[8].Push(["E", "", "5x Воинов Хаоса", cWhite])
    WavesData[8].Push(["FADH", "", "4x Огнемета", cGreen])
    WavesData[8].Push(["FJ", "", "2x Блайта", cGreen])
    WavesData[8].Push(["FGK", "", "3x Лича", cGreen])
    WavesData[8].Push(["7. ДАЛЕЕ: 160с или < 10 врагов", cCyan])
    WavesData[8].Push(["All", "", "Орда хаоса", cWhite])
    WavesData[8].Push(["*", "", "Орда скавенов", cWhite])
    WavesData[8].Push(["8. ДАЛЕЕ: 160с или < 5 врагов", cCyan])
    WavesData[8].Push(["*", "", "Орда скавенов", cWhite])
    WavesData[8].Push(["AD", "", "10x Воинов Хаоса", cWhite])
    WavesData[8].Push(["9. ДАЛЕЕ: 300с или < 1 врагов", cCyan])
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
    ; --- HEADER ---
    HeaderH := 30
    Gui, Main:Add, Progress, x0 y0 w%GuiWidth% h%HeaderH% Background%cHeader% Disabled
    Gui, Main:Font, s12 w700, Segoe UI

    ; Кнопка закрытия
    Gui, Main:Add, Text, x370 y3 w30 h25 cRed BackgroundTrans Center 0x200 gGuiClose, X

    ; Заголовок
    Gui, Main:Add, Text, x0 y3 w%GuiWidth% h20 cWhite BackgroundTrans Center 0x200 gDragWindow, FoW Спавны Катаклизм

    ; Второй ряд хедера
    Gui, Main:Font, s8 w700
    ; Левая кнопка (Hide)
    Gui, Main:Add, Text, x5 y35 w100 h20 cff5757 BackgroundTrans 0x200 gToggleOverlay, Скрыть (%Key_Toggle%)
    ; Правая кнопка (Help)
    Gui, Main:Add, Text, x290 y35 w100 h20 cfffd57 BackgroundTrans Right 0x200 gShowHelp, Настройки (%Key_Help%)
    ; Текущая волна
    Gui, Main:Font, s18 w700
    Gui, Main:Add, Text, x0 y35 w%GuiWidth% h20 cWhite BackgroundTrans Center 0x200 gDragWindow, ВОЛНА %CurrentWave%

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

            if (InStr(LeftText, "ДАЛЕЕ")) {
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

    ; --- FOOTER (Навигация) ---
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

    ; Кнопка закрытия
    Gui, Main:Add, Text, x370 y3 w30 h25 cRed BackgroundTrans Center 0x200 gGuiClose, X

    ; Заголовок
    Gui, Main:Add, Text, x0 y3 w%GuiWidth% h20 cWhite BackgroundTrans Center 0x200 gDragWindow, FoW Спавны Катаклизм

    ; Второй ряд хедера
    Gui, Main:Font, s10 w700, Segoe UI
    ; Левая кнопка (Hide)
    Gui, Main:Add, Text, x5 y32 w125 h20 c67ff57 BackgroundTrans 0x200 gToggleOverlay, Показать (%Key_Toggle%)
    ; Правая кнопка (Help)
    Gui, Main:Add, Text, x260 y32 w125 h20 cYellow BackgroundTrans Right 0x200 gShowHelp, Настройки (%Key_Help%)

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
    ; Перед открытием настроек получаем текущую позицию
    IfWinExist, %AppName%
        WinGetPos, MainX, MainY

    Gui, Help:New, +LabelHelpWin
    Gui, Help:Font, s10, Segoe UI

    ; Инфо
    Gui, Font, c666666 s11 Bold Q3, Segoe UI Black
    Gui, Help:Add, GroupBox, x10 y10 w330 h200 Center, ИНФОРМАЦИЯ
    Gui, Font,
    Gui, Add, Picture, w90 h90 x25 y25, fow icon.png
    Gui, Help:Font, s10, Segoe UI

    Gui, Add, Link, xs+130 yp+10, Автор: <a href="https://steamcommunity.com/id/ChadMasodin">ChadMasodin</a>
    Gui, Add, Text, xs+130 yp+25, Дата релиза:  10/12/2025
    Gui, Add, Text, xs+130 yp+25, Дата обновления:  10/12/2025
    Gui, Add, Link, xs+10 yp+30, Этот скрипт показывает все спавны врагов в виде`nудобного оверлея для Превратностей (Катаклизм).`n`nБолее подробную информацию о нем можно`nнайти в этом <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3619696537">руководстве.</a>

    ; Настройки
    Gui, Font, c666666 s11 Bold Q3, Segoe UI Black
    Gui, Help:Add, GroupBox, x10 y220 w330 h370 Center, НАСТРОЙКИ
    Gui, Font,
    Gui, Help:Font, s10, Segoe UI

    ; Функция для быстрого создания полей
    AddHotkeyControl("Следующая волна", "hkNext", Key_Next, 260)
    AddHotkeyControl("Предыдущая волна", "hkPrev", Key_Prev, 300)
    AddHotkeyControl("Скрыть/Показать", "hkToggle", Key_Toggle, 340)
    AddHotkeyControl("Открыть настройки", "hkHelp", Key_Help, 380)
    AddHotkeyControl("Перезагрузка", "hkReload", Key_Reload, 420)
    AddHotkeyControl("Закрыть скрипт", "hkExit", Key_Exit, 460)

    ; Слайдер прозрачности
    Gui, Help:Add, Text, x20 y500 w100, Прозрачность:
    Gui, Help:Add, Slider, x120 y500 w190 vSlAlpha Range50-255 ToolTip, %OverlayAlpha%

    ; Кнопки
    Gui, Help:Add, Button, x40 y540 w110 h30 gSaveSettings, Сохранить
    Gui, Help:Add, Button, x180 y540 w110 h30 gHelpWinClose, Отмена

    Gui, Help:Show, w350 h600, Readme
Return

AddHotkeyControl(Label, VarName, DefVal, YPos) {
    ; Устанавливаем жирный шрифт и цвет для названия настройки
    Gui, Help:Font, s10 w700 c%cLabel%
    Gui, Help:Add, Text, x20 y%YPos% w170, %Label%:
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