
event.register("magicEffectsResolved", function ()
	require("OperatorJack.Vampyr.modules.magic-effects.bloodstorm")()
	require("OperatorJack.Vampyr.modules.magic-effects.drain-blood")()
	require("OperatorJack.Vampyr.modules.magic-effects.glamour")()
	require("OperatorJack.Vampyr.modules.magic-effects.mistform")()
	require("OperatorJack.Vampyr.modules.magic-effects.resist-sun-damage")()
	require("OperatorJack.Vampyr.modules.magic-effects.restore-blood")()
end)