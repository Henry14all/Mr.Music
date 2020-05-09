;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~ 欢迎查看Mr.Music程序源码！
;~ 程序作者：HenryJiu
;~ 文件中的所有链接均为替换后的链接，并非真实链接~
;~ 想要基于本源码开发分支项目的朋友请自行寻找API接口！
;~ 版本：1.5.20.5
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Opt("GUICloseOnESC", 0)
Opt("TrayIconHide", 1)
Opt("TrayAutoPause", 0)
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiFlatButton.au3>
#include <Process.au3>
#include <FileConstants.au3>
#include <InetConstants.au3>
#include <StringConstants.au3>
#include <Sound.au3>
FileInstall("C:\Program Files (x86)\AutoIt3\Beta\Aut2Exe\Mr.Music_Color.ini", @ScriptDir & "\Mr.Music_Color.ini", $FC_NOOVERWRITE)
$Color = "0xFF0000"
$ColIni = IniRead(@ScriptDir & "\Mr.Music_Color.ini", "Color", "HEX", "Errors")
If $ColIni = "Errors" Then
	$Color = "0xFF0000"
Else
	$Color = "0x" & $ColIni
EndIf
Opt("GUICloseOnESC", 0)
Opt("TrayIconHide", 1)
Opt("TrayAutoPause", 0)
$SoundPath = 0
$QYPath = 1
Global $gogui
Global $GoLabel1
Global $OutMyURLName[0][1][2][3][4]
DirCreate(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62")
FileSetAttrib(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62", "+SH", 1)
FileInstall("C:\Program Files (x86)\AutoIt3\Beta\Aut2Exe\aria2c.exe", @TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62\aria2c.exe", $FC_OVERWRITE)
$aria2cfile = @TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62\aria2c.exe"
$TempName = @TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62\"
Start()
Func JsonToURL($JsonToURL = "")
	Local $aArrays = StringRegExp("'" & $JsonToURL & "'", "(?<Protocol>\w+):\/\/(?<Domain>[\w@][\w.:@]+)\/?[\w\.?=%&=\-@/$,]*", 0)
	If $aArrays = 0 Then
		MsgBox(262160, "错误", "无法获取到该音乐下载链接！" & @CRLF & "可能是因为：" & @CRLF & "1.该音乐为付费或灰色歌曲，无法下载" & @CRLF & "2.没有该歌曲" & @CRLF & "3.接口失效，请等待开发者更换（可能性极小）", 0)
		Return "e"
	EndIf
	Local $aArrays = StringRegExp("'" & $JsonToURL & "'", "(?<Protocol>\w+):\/\/(?<Domain>[\w@][\w.:@]+)\/?[\w\.?=%&=\-@/$,]*", $STR_REGEXPARRAYFULLMATCH)
	$aArray = $aArrays[0]
	Return $aArray
EndFunc   ;==>JsonToURL
Func Exitmsgbox()

	$Exitmsgbox = MsgBox(1 + 32 + 256, "提示", "你真的要退出吗  ╥﹏╥")
	If $Exitmsgbox = 1 Then
		FileSetAttrib(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62", "-SH", 1)
		DirRemove(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62", 1)
		Exit
	Else

	EndIf

EndFunc   ;==>Exitmsgbox
Func ReadID($MyURLName = "")
	GUICtrlSetData($Label7, "获取音乐ID中")
	If $MyURLName = "" Then
		MsgBox(266256, "错误", "非法链接！", 0)
		Return "e"
	EndIf
	Local $OutMyURLNames = StringRegExp("'" & $MyURLName & "'", "id=(\d+)", 1)
	If $OutMyURLNames = 0 Then
		MsgBox(266256, "错误", "非法链接！", 0)
		Return "e"
	EndIf
	Local $OutMyURLNames = StringRegExp("'" & $MyURLName & "'", "id=(\d+)", 2)
	$OutMyURLName = $OutMyURLNames[1]
	GUICtrlSetData($Label7, "音乐ID获取成功")
	Return $OutMyURLName
EndFunc   ;==>ReadID
Func DownMusic($MusicID = "")
	GUICtrlSetData($Label7, "开始获取链接")
	$Get = InetRead("http://x.x.x.x/song/url?id=" & $MusicID, 1)
	$GetOut = BinaryToString($Get)
	$GetURL = JsonToURL($GetOut)
	If $GetURL = "e" Then
		Return "e"
	EndIf
	GUICtrlSetData($Label7, "开始下载音乐")
	$InputBox = InputBox("歌曲重命名工具", "你可以通过它来修改下载时的文件名~" & @CRLF & "请在下方输入新的文件名（无需输入后缀）" & @CRLF & "若是不想重命名，请直接点击取消按钮！" & @CRLF & "15秒后按原始文件名下载！", "", "", 260, 200, Default, Default, 15)
	If $InputBox = "" Then
		RunWait($aria2cfile & " " & "-x 16 " & $GetURL, "", @SW_HIDE)
	Else
		RunWait($aria2cfile & " " & "-x 16 -o " & $InputBox & ".mp3 " & $GetURL, "", @SW_HIDE)
	EndIf
	GUICtrlSetData($Label7, "下载完成")
	MsgBox(266304, "提示", "音乐下载完成！请前往程序所在目录查看！", 0)
EndFunc   ;==>DownMusic
Func Start()
	$gogui = GUICreate("程序初始化中...", 624, 192, -1, -1, $WS_POPUP)
	GUISetBkColor(0xFFFBF0)
	GUICtrlCreateLabel("Mr. Music-网易云音乐下载器", 107, 24, 409, 46)
	GUICtrlSetFont(-1, 23, 400, 0, "微软雅黑")
	GUICtrlSetColor(-1, 0x000000)
	$GoGraphic1 = GUICtrlCreateGraphic(7, 7, 608, 177)
	GUICtrlSetColor(-1, 0x000000)
	$GoLabel1 = GUICtrlCreateLabel("正在初始化模块", 230, 78, 170, 29)
	GUICtrlSetFont(-1, 14, 400, 0, "微软雅黑")
	GUICtrlSetColor(-1, 0x000000)
	$GoLabel2 = GUICtrlCreateLabel("永久免费，严禁倒卖", 237, 119, 148, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "微软雅黑")
	GUISetState(@SW_SHOW)
	Update()
	GUIDelete($gogui)
	Return
EndFunc   ;==>Start
Func Update()
	GUICtrlSetData($GoLabel1, "正在连接更新服务器")
	Local $dData = InetRead("http://xxx.xxx.site/MrMusicUp.txt", $INET_FORCERELOAD)
	GUICtrlSetData($GoLabel1, "正在连接接口服务器")
	Local $dData163 = InetRead("http://x.x.x.x", $INET_FORCERELOAD)

	If $dData = "" Then
		If Not $dData163 = "" Then
			MsgBox(262192, "警告", "无法连接至更新服务器！将无法检查更新！" & @CRLF & "但可以连接至接口服务器，可以继续使用！", 0)
			Return
		Else
			MsgBox(262160, "错误", "服务器连接失败！", 0)
			FileSetAttrib(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62", "-SH", 1)
			DirRemove(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62", 1)
			Exit
		EndIf
	EndIf

	$dDataout = BinaryToString($dData)

	If $dDataout = '1.5.20.5' Then
		Return
	Else
		GUIDelete($gogui)
		MsgBox(48 + 262144, "Mr. Music更新程序", "有新版本需要更新！" & @CRLF & "当前版本号：" & '1.5.20.5' & @CRLF & "最新版本号：" & $dDataout & @CRLF & "请注意比较版本号大小，避免向后更新！" & @CRLF & "按确定键访问项目地址！")
		_RunDos("start https://github.com/Henry14all/Mr.Music/releases")
		Exit
	EndIf
EndFunc   ;==>Update
Func ApiGet($QY)
	If $QY = 1 Then
		$QYName = "热歌榜"
	EndIf
	If $QY = 2 Then
		$QYName = "新歌榜"
	EndIf
	If $QY = 3 Then
		$QYName = "飙升榜"
	EndIf
	If $QY = 4 Then
		$QYName = "抖音榜"
	EndIf
	If $QY = 5 Then
		$QYName = "电音榜"
	EndIf
	GuiFlatButton_SetData($Button3, "加载中...")
	RunWait($aria2cfile & " " & "-x 16 https://api.xxx.com/api/rand.music?sort=" & $QYName & " -o MusicTemp.mp3", $TempName, @SW_HIDE)
	$SoundPlay = SoundPlay($TempName & "MusicTemp.mp3")
	$SoundPath = 1
	GuiFlatButton_SetData($Button3, "点击播放/停止")
EndFunc   ;==>ApiGet
Func AboutGUI()
	$AForm1 = GUICreate("关于", 455, 220, -1, -1, $WS_POPUP)
	GUISetFont(8, 400, 0, "微软雅黑")
	GUISetBkColor(0xFFFBF0)
	$ALabel1 = GUICtrlCreateLabel("Mr. Music-网易云音乐下载器", 48, 8, 360, 39)
	GUICtrlSetFont(-1, 20, 400, 0, "微软雅黑")
	$ALabel2 = GUICtrlCreateLabel("小啾 版权所有", 176, 56, 105, 25)
	GUICtrlSetFont(-1, 12, 400, 0, "微软雅黑")
	$ALabel3 = GUICtrlCreateLabel("本程序仅供学习交流API调用技术以及多线程下载使用，请勿用于商业用途！", 8, 136, 441, 23)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	$ALabel4 = GUICtrlCreateLabel("请在下载后24小时之内从您的任何介质内（包括但不限于您分享出去的文件）", 8, 88, 450, 23)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	$ALabel5 = GUICtrlCreateLabel("完全、彻底地删除本程序及其下载的文件！", 104, 112, 251, 23)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	$AButton1 = GuiFlatButton_Create("确定", 147, 168, 161, 33)
	GUICtrlSetFont(-1, 10, 400, 0, "微软雅黑")
	GUISetState(@SW_SHOW)

	While 2
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Return
			Case $AButton1
				GUIDelete()
				Return

		EndSwitch
	WEnd

EndFunc   ;==>AboutGUI

$MusicMr = GUICreate("Mr. Music网易云音乐下载器", 623, 329, -1, -1, $WS_POPUP)
GUISetFont(8, 400, 0, "Segoe UI")
GUISetBkColor(0xFFFBF0)
$Input1 = GUICtrlCreateInput("", 29, 161, 563, 23)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, $Color)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label5 = GUICtrlCreateLabel("网易云音乐链接：", 28, 140, 108, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
$Label1 = GUICtrlCreateLabel(" Mr. Music", 0, 0, 623, 25, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 12, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
$Button1 = GuiFlatButton_Create("X", 601, -2, 21, 25)
GuiFlatButton_SetColors(-1, $Color, 0xFFFFFF, $Color)
GUICtrlSetFont(-1, 13, 500, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
$ButtonC = GuiFlatButton_Create("-", 575, -2, 21, 25)
GuiFlatButton_SetColors(-1, $Color, 0xFFFFFF, $Color)
GUICtrlSetFont(-1, 22, 500, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
$Graphic1 = GUICtrlCreateGraphic(21, 35, 579, 67)
GUICtrlSetColor(-1, $Color)
$Label2 = GUICtrlCreateLabel("随机推荐", 28, 28, 56, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
$Graphic2 = GUICtrlCreateGraphic(21, 125, 579, 97)
GUICtrlSetColor(-1, $Color)
$Label3 = GUICtrlCreateLabel("音乐下载", 28, 119, 56, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
$Graphic3 = GUICtrlCreateGraphic(21, 245, 579, 67)
GUICtrlSetColor(-1, $Color)
$Label4 = GUICtrlCreateLabel("更多", 28, 238, -1, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
$Button2 = GuiFlatButton_Create("解析并下载~", 452, 190, 138, 26)
GuiFlatButton_SetColors(-1, $Color, 0xFFFFFF, $Color)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
$Label6 = GUICtrlCreateLabel("当前状态：", 35, 196, 84, 21)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
$Label7 = GUICtrlCreateLabel("已就绪", 119, 196, 200, 21)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
$Button3 = GuiFlatButton_Create("点击播放/停止", 91, 49, 437, 44)
GuiFlatButton_SetColors(-1, $Color, 0xFFFFFF, $Color)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
$Button4 = GuiFlatButton_Create("关于", 457, 267, 130, 29)
GuiFlatButton_SetColors(-1, $Color, 0xFFFFFF, $Color)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
$Button5 = GuiFlatButton_Create("项目Github地址", 30, 267, 130, 29)
GuiFlatButton_SetColors(-1, $Color, 0xFFFFFF, $Color)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $Color)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $Button1
			Exitmsgbox()
		Case $Button2
			$InputIDName = GUICtrlRead($Input1)
			$MusicID = ReadID($InputIDName)
			If $MusicID = "e" Then
				GUICtrlSetData($Label7, "已就绪")
				ContinueLoop
			EndIf
			$DownMusicPath = DownMusic($MusicID)
			If $DownMusicPath = "e" Then
				GUICtrlSetData($Label7, "已就绪")
				ContinueLoop
			EndIf
		Case $Button4
			AboutGUI()
		Case $Button5
			_RunDos("start https://github.com/Henry14all/Mr.Music/")
		Case $Button3
			If $SoundPath = 1 Then
				SoundPlay("")
				FileSetAttrib(@TempDir & "\Z7815621dhjfknhdfxj144876551546197958961916dsajkflpectuy62\*.mp3", "-SH", 1)
				FileDelete($TempName & "*.mp3")
				$SoundPath = 0
			Else
				If $QYPath = 1 Then
					ApiGet(1)
					$QYPath = 2
					ContinueLoop
				EndIf
				If $QYPath = 2 Then
					ApiGet(2)
					$QYPath = 3
					ContinueLoop
				EndIf
				If $QYPath = 3 Then
					ApiGet(3)
					$QYPath = 4
					ContinueLoop
				EndIf
				If $QYPath = 4 Then
					ApiGet(4)
					$QYPath = 5
					ContinueLoop
				EndIf
				If $QYPath = 5 Then
					ApiGet(5)
					$QYPath = 1
					ContinueLoop
				EndIf
			EndIf
		Case $ButtonC
			DllCall("user32.dll", "BOOL", "CloseWindow", "hWnd", $MusicMr)
	EndSwitch
WEnd
