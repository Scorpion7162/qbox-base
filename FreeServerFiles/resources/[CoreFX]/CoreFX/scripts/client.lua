local function starts_with(str, start)
    return str:sub(1, #start) == start
end

Citizen.CreateThread(function()
    for _, d in ipairs({
        {"corefx_fxweather", {"platform:/textures/fxweather", "distortion_rain_n", "rain"}},
        {"corefx_graphics", {"platform:/textures/graphics", "bikebottom", "bokeh_8sided_iris_4x4sheet", "carbottom", "corona", "flare_artefactx2", "flare_chromatic", "flare_corona", "helibottom", "motorbikebottom"}},
        {"corefx_skydome", {"platform:/textures/skydome", "dither", "noise16_p", "starfield"}},
        {"corefx_vehshare", {"vehshare", "vehicle_generic_alloy_silver_spec", "vehicle_genericmud_car", "vehicle_generic_glasswindows2"}}
    }) do
        RequestStreamedTextureDict(d[1], false)
        while not HasStreamedTextureDictLoaded(d[1]) do Wait(100) end
        for i = 2, #d[2] do AddReplaceTexture(d[2][1], d[2][i], d[1], d[2][i]) end
    end

    for line in LoadResourceFile("CoreFX", "data/visualsettings.dat"):gmatch("[^\r\n]+") do
        if not starts_with(line, "#") and not starts_with(line, "//") and line:find("%S") then
            local key, value = line:match("(%S+)%s+(%S+)")
            if key and tonumber(value) and key ~= "weather.CycleDuration" then
                SetVisualSettingFloat(key, tonumber(value) + 0.0)
            end
        end
    end

    if config.options.BrighterEmergencyLights then
        SetVisualSettingFloat("car.defaultlight.day.emissive.on", 7000.0)
        SetVisualSettingFloat("car.defaultlight.night.emissive.on", 1000.0)
    end

    if config.options.RemoveCorona then
        SetVisualSettingFloat("misc.coronas.sizeScaleGlobal", 0.0)
        SetVisualSettingFloat("misc.coronas.intensityScaleGlobal", 0.0)
    end
end)