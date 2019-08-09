--################# A modification of Tad2020's GetAllConstrainedEntities function -This basically also fetches the worldentity and has a MaxPasses offset to save performance
if (Stargate) then
	function StarGate.GetConstrainedEnts(ent,max_passes,passes,entities,cons)
		if(not ValidEntity(ent)) then return {},{} end;
		local entities,cons = (entities or {}),(cons or {});
		local passes = (passes or 0)+1;
		if(max_passes and passes > max_passes) then return end;
		if(not entities[ent]) then
			if(not constraint.HasConstraints(ent)) then return {},{} end;
			entities[ent] = ent;
			for _,v in pairs(ent.Constraints) do
				if(not cons[v]) then
					cons[v] = v;
					for i=1,6 do
						local e = v["Ent"..i];
						if(e) then
							if(e:IsValid()) then
								StarGate.GetConstrainedEnts(e,max_passes,passes,entities,cons);
							elseif(not entities[e] and e:IsWorld()) then
								entities[e] = e;
							end
						end
					end
				end
			end
		end
		return table.ClearKeys(entities),table.ClearKeys(cons);
	end
end