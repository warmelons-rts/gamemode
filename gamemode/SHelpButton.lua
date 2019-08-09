/*
	Stargate for GarrysMod10
	Copyright (C) 2007  aVoN

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
--This is pretty much just a rip of aVoN's StarGate Help Button.
-- Help Button

HELPBUTTON = {};

--################# Inits @aVoN
function HELPBUTTON:Init()
	self:SetSize(self:GetParent():GetWide(),25);
	self:SetToolTip("Click here to get additional Information");
	self:SetCursor("hand");
	self.Topic = "Help";
	-- VGUI Elements
	self.VGUI = {
		HelpImage = vgui.Create("DImage",self),
		HelpLabel = vgui.Create("DLabel",self),
	}
	-- Help image
	self.VGUI.HelpImage:SetPos(5,4);
	self.VGUI.HelpImage:SetSize(16,16);
	self.VGUI.HelpImage:SetImage("gui/info");
	
	-- Help Label
	self.VGUI.HelpLabel:SetPos(23,3);
	self.VGUI.HelpLabel:SetWide(500);
	self.VGUI.HelpLabel:SetText("Help");
end

local VGUI;
--################# Open the HELP @aVoN
function HELPBUTTON:OnMousePressed()
    RunConsoleCommand("wmencyclopedia", self.Topic )
end

--################# Adds the Topic of the HTML Frame @aVoN
function HELPBUTTON:SetTopic(text)
	self.Topic = text;
end

--################# Set's the label's Text @aVoN
function HELPBUTTON:SetText(text)
	self.VGUI.HelpLabel:SetText(text);
end

--################# Set's the label's Text @aVoN
function HELPBUTTON:SetImage(image)
	self.VGUI.HelpImage:SetImage(image);
end

--################# Paint @aVoN
function HELPBUTTON:Paint()
	draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(16,16,16,100));
	return true;
end

vgui.Register("WMHelpButton",HELPBUTTON,"Panel");