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
	Released under MIT-license by Tero @ RC-Thoughts.com 2017
	---------------------------------------------------------
--]]
collectgarbage()
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
	form.addIntbox(bLightIdle,-0,1000,0,0,1,bLightIdleChanged)
	
	form.addRow(2)
	form.addLabel({label=trans9.bLightMode,width=220})
	form.addIntbox(bLightModeIdle,-0,3,0,0,1,bLightModeIdleChanged)
	
	form.addRow(2)
	form.addLabel({label=trans9.volume,width=220})
	form.addIntbox(volIdle,-0,16,0,0,1,volIdleChanged)
	
	form.addRow(2)
	form.addLabel({label=trans9.volPlay,width=220})
	form.addIntbox(volPlayIdle,-0,100,0,0,1,volPlayIdleChanged)
	
	form.addRow(2)
	form.addLabel({label=trans9.volBeep,width=220})
	form.addIntbox(volBeepIdle,-0,100,0,0,1,volBeepIdleChanged)
	
	-- In use
	form.addRow(1)
	form.addLabel({label=trans9.inUse,font=FONT_BOLD})
	
	form.addRow(2)
	form.addLabel({label=trans9.bLight,width=220})
	form.addIntbox(bLightUse,-0,1000,0,0,1,bLightUseChanged)
	
	
	form.addRow(2)
	form.addLabel({label=trans9.bLightMode,width=220})
	form.addIntbox(bLightModeUse,-0,3,0,0,1,bLightModeUseChanged)
	
	
	form.addRow(2)
	form.addLabel({label=trans9.volume,width=220})
	form.addIntbox(volUse,-0,16,0,0,1,volUseChanged)
	
	form.addRow(2)
	form.addLabel({label=trans9.volPlay,width=220})
	form.addIntbox(volPlayUse,-0,100,0,0,1,volPlayUseChanged)
	
	form.addRow(2)
	form.addLabel({label=trans9.volBeep,width=220})
	form.addIntbox(volBeepUse,-0,100,0,0,1,volBeepUseChanged)
	
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
		propSet = 1
    end
	if(inUse ~= 1 and propSet == 1) then
		system.setProperty("Backlight", bLightIdle)
		system.setProperty("BacklightMode", bLightModeIdle)
		system.setProperty("Volume", volIdle)
		system.setProperty("VolumePlayback", volPlayIdle)
		system.setProperty("VolumeBeep", volBeepIdle)
		propSet = 0
    end
end
--------------------------------------------------------------------------------
local function firstInit()
	bLightIdle = system.getProperty("Backlight")
	bLightIdle = tonumber(bLightIdle)
	bLightUse = bLightIdle
	
	bLightModeIdle = system.getProperty("BacklightMode")
	bLightModeIdle = tonumber(bLightModeIdle)
	bLightModeUse = bLightModeIdle
	
	volIdle = system.getProperty("Volume")
	volIdle = tonumber(volIdle)
	volUse = volIdle
	
	volPlayIdle = system.getProperty("VolumePlayback")
	volPlayIdle = tonumber(volPlayIdle)
	volPlayUse = volPlayIdle
	
	volBeepIdle = system.getProperty("VolumeBeep")
	volBeepIdle = tonumber(volBeepIdle)
	volBeepUse = volBeepIdle
    
    system.pSave("bLightIdle",bLightIdle)
    system.pSave("bLightUse",bLightUse)
    system.pSave("bLightModeIdle",bLightModeIdle)
    system.pSave("bLightModeUse",bLightModeUse)
    system.pSave("volIdle",volIdle)
    system.pSave("volUse",volUse)
    system.pSave("volPlayIdle",volPlayIdle)
    system.pSave("volPlayUse",volPlayUse)
    system.pSave("volBeepIdle",volBeepIdle)
    system.pSave("volBeepUse",volBeepUse)
end
--------------------------------------------------------------------------------
local function init()
	system.registerForm(1,MENU_APPS, trans9.appName,initForm,nil,printForm)
	comfSwitch = system.pLoad("comfSwitch")
	if(comfSwitch == nil) then
		firstInit()
    end
    if(comfSwitch ~= nil) then
		bLightIdle = system.pLoad("bLightIdle")
		bLightUse = system.pLoad("bLightUse")
		bLightModeIdle = system.pLoad("bLightModeIdle")
		bLightModeUse = system.pLoad("bLightModeUse")
		volIdle = system.pLoad("volIdle")
		volUse = system.pLoad("volUse")
		volPlayIdle = system.pLoad("volPlayIdle")
		volPlayUse = system.pLoad("volPlayUse")
		volBeepIdle = system.pLoad("volBeepIdle")
		volBeepUse = system.pLoad("volBeepUse")
    end
    collectgarbage()
end
--------------------------------------------------------------------------------
comfVersion = "1.2"
collectgarbage()
setLanguage()
return {init=init,loop=loop,author="RC-Thoughts",version=comfVersion,name="Comfortable"}