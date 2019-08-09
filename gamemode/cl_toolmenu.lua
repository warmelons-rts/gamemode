
-- What toolname corresponds to what tool.
local toolnames  = {}
toolnames["Cannons"] = "lap_cannons"
toolnames["Explosivses"] = "lap_bombs"
toolnames["Fighters"] = "fightars"
toolnames["Flak Cannons"] = "lap_flak"
toolnames["Harvesters"] = "lap_harvesters"
toolnames["Lasers"] = "lasermelon"
toolnames["Launcher"] = "lap_launchers"
toolnames["Light Fighter"] = "l_fightars"
toolnames["Machine Gunners"] = "lap_mgs"
toolnames["Medics"] = "medics"
toolnames["Mortars"] = "lap_mortar"
toolnames["Order Cores"] = "ordermelons"
toolnames["Plasma Cannons"] = "pcannons"
toolnames["Snipers"] = "lap_snipers"
toolnames["Strikers"] = "lap_strikers"
toolnames["Torpedo Launcher"] = "lap_torplaunchs"
toolnames["Barracks"] = "barrax"
toolnames["CapPoint Fortification"] = "lap_cappointforts"
toolnames["Heavy Barracks"] = "heavybarrax"
toolnames["Munitions Factory"] = "munitions"
toolnames["Outputs"] = "lap_outposts"
toolnames["Spawn Point"] = "lap_spawnpoints"
toolnames["Ballast Tank"] = "lap_ballast"
toolnames["Base Prop"] = "baseprops"
toolnames["Melon Strike"] = "lap_canisters"
toolnames["Recycle"] = "lap_recycle"
toolnames["Superweapons"] = "lap_superweapons"
toolnames["Transport"] = "lap_transport"
toolnames["Adv.Duplicator - WM"] = "adv_duplicator"

-- Categories
local categories = {}

local melons = {}
local structures = {}
local other = {}
local custom = {}

categories["melons"]		= melons
categories["structures"]	= structures
categories["other"]			= melons
categories["custom"]		= custom

-- What category every tool is in
local tools = {}
tools["lap_cannons"]		= {melons}
tools["fightars"]			= {melons}
tools["lap_flak"]			= {melons}
tools["lap_harvesters"]		= {melons}
tools["lasermelon"]			= {melons}
tools["lap_torplaunchs"]	= {melons}
tools["l_fightars"]			= {melons}
tools["lap_mgs"]			= {melons}
tools["medics"]				= {melons}
tools["lap_mortar"]			= {melons}
tools["ordermelons"]		= {melons}
tools["pcannons"]			= {melons}
tools["lap_snipers"]		= {melons}
tools["lap_strikers"]		= {melons}
tools["lap_bombs"]			= {melons}
tools["barrax"]				= {structures}
tools["heavybarrax"]		= {structures}
tools["munitions"]			= {structures}
tools["lap_cappointforts"]	= {structures}
tools["lap_outposts"]		= {structures}
tools["lap_spawnpoints"]	= {structures}
tools["lap_ballast"]		= {structures}
tools["baseprops"]			= {structures}
tools["lap_superweapons"]	= {other}
tools["lap_launchers"]		= {other}
tools["lap_transport"]		= {other}
tools["lap_canisters"]		= {other}
tools["adv_duplicator"]		= {other}
tools["lap_recycle"]		= {other}

-- Put the tools in their chosen categories
for k,v in pairs(toolnames) do
	for _,categories in pairs(tools[v]) do
		for _,category in pairs(categories]) do
			category[k] = v
		end
	end
end


-- Creates the toolmenu for the listed categories
local function toolmenu(ply, cmd , args)
	local toolFrame = vgui.Create( "DFrame" ) 
	toolFrame:SetPos( 50,50 ) 
	toolFrame:SetSize( 350, 500 ) 
	toolFrame:SetTitle( "WarMelons Tools" ) 
	toolFrame:SetVisible( true )
	toolFrame:SetDraggable( true ) 
	toolFrame:ShowCloseButton( true ) 
	toolFrame:MakePopup() 
	
	local propertySheet = vgui.Create( "DPropertySheet", toolFrame )
	propertySheet:SetPos( 5, 30 )
	propertySheet:SetSize( 340, 460 )
	
	for k,v in pairs(categories) do
		local sheetItem = vgui.Create( "DPanel", toolFrame )
		sheetItem:SetPos( 5, 23 )
		sheetItem:SetSize( 325, 490 )
		
		local melonList = vgui.Create("DListView",sheetItem)
		melonList:SetPos(5, 5)
		melonList:SetSize(315, 410)
		melonList:SetMultiSelect(false)
		melonList:AddColumn(k)
			-- Add all the lines
			for name,tool in pairs(v) do
				melonList:AddLine(k)
			end
			
		melonList.DoDoubleClick = function(parent, index, list)
			RunConsoleCommand("gmod_toolmode", toolnames[list:GetValue(1)]
			RunConsoleCommand("use", "gmod_tool")
			toolFrame.Close()
		end
		
		propertySheet:AddSheet( k, sheetItem, "gui/silkicons/user", false, false, k )
	end
end
concommand.Add("toolmenu", toolmenu)
