function fix_resources_for_surface(surface, area)
	resources = surface.find_entities_filtered({
		area = area,
		type = "resource",
	})
	for _, resource in pairs(resources) do
		if resource.prototype.infinite_resource then
			-- set all new resources to exactly their normal amount
			local multiplier = 1
			if resource.prototype.resource_category == "basic-fluid" then
				multiplier = settings.global["infinite-resources-multiplier-fork-fluid-yield-multiplier"].value
			end

			resource.initial_amount = resource.prototype.normal_resource_amount * multiplier
			resource.amount = resource.prototype.normal_resource_amount * multiplier
		end
	end
end

script.on_configuration_changed(function()
	for _, surface in pairs(game.surfaces) do
		fix_resources_for_surface(surface)
	end
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	fix_resources_for_surface(event.surface, event.area)
end)

script.on_event(defines.events.on_surface_created, function(event)
	fix_resources_for_surface(game.surfaces[event.surface_index])
end)
