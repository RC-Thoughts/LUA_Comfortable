--[[
	---------------------------------------------------------
    Comfortable is an application where user can set different
	sound- and beep volumes and backlight configurations for 
	idle and use. 
	
	Main usage would be for example backlight always on and
	louder volume during use and less when being idle on 
	pit-area for example.
	
	Italian translation courtesy from Fabrizio Zaini
	---------------------------------------------------------
	Localisation-file has to be as /Apps/Lang/RCT-Comf.jsn
	---------------------------------------------------------
	Comfortable is part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
	Released under MIT-license by Tero @ RC-Thoughts.com 2016
	---------------------------------------------------------
--]]
--------------------------------------------------------------------------------
-- Locals for application
local bLightIdle, bLightUse, bLightModeIdle, bLightModeUse, comfSwitch
local volIdle, volUse, volPlayIdle, volPlayUse, volBeepIdle, volBeepUse
local propSet, inUse = 0, 0
--------------------------------------------------------------------------------
-- Function for translation file-reading
local function readFile(path) 
	local f = io.open(path,"r")
	local lines={}
	if(f) then
		while 1 do 
			local buf=io.read(f,512)
			if(buf ~= "")then 
				lines[#lines+1] = buf
				else
				break   
			end   
		end 
		io.close(f)
		return table.concat(lines,"") 
	end
end 
--------------------------------------------------------------------------------
-- Read translations
local function setLanguage()	
	local lng=system.getLocale();
	local file = readFile("Apps/Lang/RCT-Comf.jsn")
	local obj = json.decode(file)  
	if(obj) then
		trans9 = obj[lng] or obj[obj.default]
	end
end
--------------------------------------------------------------------------------
local function bLightIdleChanged(value)
	bLightIdle = value
	system.pSave("bLightIdle",value)
end

local function bLightUseChanged(value)
	bLightUse = value
	system.pSave("bLightUse",value)
end

local function bLightModeIdleChanged(value)
	bLightModeIdle = value
	system.pSave("bLightModeIdle",value)
end

local function bLightModeUseChanged(value)
	bLightModeUse = value
	system.pSave("bLightModeUse",value)
end

local function volIdleChanged(value)
	volIdle = value
	system.pSave("volIdle",value)
end

local function volUseChanged(value)
	volUse = value
	system.pSave("volUse",value)
end

local function volPlayIdleChanged(value)
	volPlayIdle = value
	system.pSave("volPlayIdle",value)
end

local function volPlayUseChanged(value)
	volPlayUse = value
	system.pSave("volPlayUse",value)
end

local function volBeepIdleChanged(value)
	volBeepIdle = value
	system.pSave("volBeepIdle",value)
end

local function volBeepUseChanged(value)
	volBeepUse = value
	system.pSave("volBeepUse",value)
end

local function comfSwitchChanged(value)
	comfSwitch = value
	system.pSave("comfSwitch",value)
end
--------------------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
	form.addRow(1)
	form.addLabel({label="---     RC-Thoughts Jeti Tools      ---",font=FONT_BIG})
	
	form.addRow(2)
	form.addLabel({label=trans9.sw,width=220})
	form.addInputbox(comfSwitch,true,comfSwitchChanged) 
	
	form.addRow(1)
	form.addLabel({label=trans9.inIdle,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans9.bLight,width=220})
	form.addIntbox(bLightIdle,-0,1000,0,0,1,bLightIdle)
	
	form.addRow(2)
	form.addLabel({label=trans9.bLightMode,width=220})
	form.addIntbox(bLightModeIdle,-0,3,0,0,1,bLightModeIdle)
	
	form.addRow(2)
	form.addLabel({label=trans9.volume,width=220})
	form.addIntbox(volIdle,-0,16,0,0,1,volIdle)
	
	form.addRow(2)
	form.addLabel({label=trans9.volPlay,width=220})
	form.addIntbox(volPlayIdle,-0,100,0,0,1,volPlayIdle)
	
	form.addRow(2)
	form.addLabel({label=trans9.volBeep,width=220})
	form.addIntbox(volBeepIdle,-0,100,0,0,1,volBeepIdle)
	
	-- In use
	form.addRow(1)
	form.addLabel({label=trans9.inUse,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans9.bLight,width=220})
	form.addIntbox(bLightUse,-0,1000,0,0,1,bLightUse)
	
	
	form.addRow(2)
	form.addLabel({label=trans9.bLightMode,width=220})
	form.addIntbox(bLightModeUse,-0,3,0,0,1,bLightModeUse)
	
	
	form.addRow(2)
	form.addLabel({label=trans9.volume,width=220})
	form.addIntbox(volUse,-0,16,0,0,1,volUse)
	
	form.addRow(2)
	form.addLabel({label=trans9.volPlay,width=220})
	form.addIntbox(volPlayUse,-0,100,0,0,1,volPlayUse)
	
	form.addRow(2)
	form.addLabel({label=trans9.volBeep,width=220})
	form.addIntbox(volBeepUse,-0,100,0,0,1,volBeepUse)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com - v."..comfVersion.." ",font=FONT_MINI, alignRight=true})
end
--------------------------------------------------------------------------------
local function loop()
	local inUse  = system.getInputsVal(comfSwitch)
	if(inUse == 1 and propSet == 0) then
		system.setProperty("Backlight", bLightUse)
		system.setProperty("BacklightMode", bLightModeUse)
		system.setProperty("Volume", volUse)
		system.setProperty("VolumePlayback", volPlayUse)
		system.setProperty("VolumeBeep", volBeepUse)
		local propSet = 1
	end
	if(inUse == 0 and propSet == 1) then
		system.setProperty(Backlight, bLightIdle)
		system.setProperty(BacklightMode, bLightModeIdle)
		system.setProperty(Volume, volIdle)
		system.setProperty(VolumePlayback, volPlayIdle)
		system.setProperty(VolumeBeep, volBeepIdle)
		local propSet = 0
	end
end
--------------------------------------------------------------------------------
local function firstInit()
	bLightIdle = system.getProperty("Backlight")
	bLightIdle = tonumber(bLightIdle)
	bLightUse = bLightIdle
	print("Backlight ", bLightIdle)
	
	bLightModeIdle = system.getProperty("BacklightMode")
	bLightModeIdle = tonumber(bLightModeIdle)
	bLightModeUse = bLightModeIdle
	print("Backlight Mode ", bLightModeIdle)
	
	volIdle = system.getProperty("Volume")
	volIdle = tonumber(volIdle)
	volUse = volIdle
	print("Volume ", volIdle)
	
	volPlayIdle = system.getProperty("VolumePlayback")
	volPlayIdle = tonumber(volPlayIdle)
	volPlayUse = volPlayIdle
	print("Volume Sound ", volPlayIdle)
	
	volBeepIdle = system.getProperty("VolumeBeep")
	volBeepIdle = tonumber(volBeepIdle)
	volBeepUse = volBeepIdle
	print("Volume Beep ", volBeepIdle)
end
--------------------------------------------------------------------------------
local function init()
	system.registerForm(1,MENU_APPS, trans9.appName,initForm,nil,printForm)
	system.pLoad("comfSwitch")
	print("Switch ", comfSwitch)
	if(comfSwitch == nil) then
		firstInit()
		else
		system.pLoad("bLightIdle")
		system.pLoad("bLightUse")
		system.pLoad("bLightModeIdle")
		system.pLoad("bLightModeUse")
		system.pLoad("volIdle")
		system.pLoad("volUse")
		system.pLoad("volPlayIdle")
		system.pLoad("volPlayUse")
		system.pLoad("volBeepIdle")
		system.pLoad("volBeepUse")
	end
end
--------------------------------------------------------------------------------
comfVersion = "1.1"
setLanguage()
return {init=init,loop=loop,author="RC-Thoughts",version=comfVersion,name="Comfortable"} 	