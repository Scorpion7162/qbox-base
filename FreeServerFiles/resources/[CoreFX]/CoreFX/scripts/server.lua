local gameBuild = GetConvarInt("sv_enforceGameBuild", 0)
local resource = gameBuild >= 3258 and (config.options.CoffeeStreetLights and "CoreFX_lights_post3258" or "CoreFX_post3258") or (config.options.CoffeeStreetLights and "CoreFX_lights_pre3258" or "CoreFX_pre3258")
ExecuteCommand("start " .. resource)

local c,o,f=config.options,"^2ON^7","^8OFF^7" 
print("\n^2                                   fff")
print("  cccc    cccc    rr rr     eee   ff    xx  xx ")
print("cc      cc    cc  rrr  r  ee   e  ffff    xx   ")
print("cc      cc    cc  rr      eeeee   ff      xx   ")
print(" ccccc   ccccc    rr       eeeee  ff    xx  xx ^7(" .. GetResourceMetadata("CoreFX", "version") ..")")
print("\n^7Visit the discord server: ^5https://discord.gg/jK4SRmBqYt\n")
print("^71. Brighter Emergency Lights (" .. (c.BrighterEmergencyLights and o or f) .. ")")
print("^72. Coffee Street Lights (" .. (c.CoffeeStreetLights and o or f) .. ")")
print("^73. Remove Corona (" .. (c.RemoveCorona and o or f) .. ")\n")