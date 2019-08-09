function EFFECT:Init (data)
	local emit = ParticleEmitter (data:GetOrigin());
	for i=0, 20 do
		local part = emit:Add ("effects/spark", data:GetOrigin());
		part:SetVelocity(VectorRand()*65);
		part:SetLifeTime(0);
		part:SetDieTime(2);
		part:SetStartSize(10);
		part:SetEndSize(0);
		part:SetRoll(math.Rand(0, 360));
		part:SetRollDelta(0);
		part:SetAirResistance(50);
		part:SetGravity(Vector(0, 0, 600));
	end
	emit:Finish();
end

function EFFECT:Think ()
	return false;
end

function EFFECT:Render()
end
