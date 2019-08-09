function EFFECT:Init (data)
	local emit = ParticleEmitter (data:GetOrigin());
	for i=0, 10 do
		local part = emit:Add ("effects/redflare", data:GetOrigin());
		part:SetVelocity(VectorRand()*35);
		part:SetLifeTime(0);
		part:SetDieTime(1);
		part:SetStartSize(12);
		part:SetEndSize(0);
		part:SetRoll(0);
		part:SetRollDelta(0);
		part:SetAirResistance(0);
		part:SetGravity(Vector(0, 0, 0));
	end
	emit:Finish();
end

function EFFECT:Think ()
	return false;
end

function EFFECT:Render()
end
