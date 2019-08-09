function EFFECT:Init (fx)
	self.Lazer = Material("sprites/bluelaser1");
	self.Start = fx:GetStart();
	self.End = fx:GetOrigin();
	self.Time = 0;
	self.DTime = 0.3;
end

function EFFECT:Think ()
	self.Time = self.Time + FrameTime();
	return self.Time <= self.DTime;
end

function EFFECT:Render()
	render.SetMaterial(self.Lazer);
	render.DrawBeam (self.Start, self.End, 10, 0, 0, Color(50, 50, 50, 255 - (self.Time/self.DTime)*255));
end
