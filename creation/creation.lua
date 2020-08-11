lastCreatedZoneType = nil
lastCreatedZone = nil
createdZoneType = nil
createdZone = nil
drawZone = false

RegisterNetEvent("polyzone:pzcreate")
AddEventHandler("polyzone:pzcreate", function(zoneType, name)
  if createdZone ~= nil then
    TriggerEvent('chat:addMessage', {
      color = { 255, 0, 0},
      multiline = true,
      args = {"Me", "A shape is already being created!"}
    })
    return
  end
  
  if zoneType == 'poly' then
    polyStart(name)
  elseif zoneType == "circle" then
    local radius = tonumber(GetUserInput("Enter radius:"))
    if radius == nil then
      TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "CircleZone requires a radius (must be a number)!"}
      })
      return
    end
    circleStart(name, radius)
  elseif zoneType == "box" then
    local length = tonumber(GetUserInput("Enter length:"))
    if length == nil or length < 0.0 then
      TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "BoxZone requires a length (must be a positive number)!"}
      })
      return
    end
    local width = tonumber(GetUserInput("Enter width:"))
    if width == nil or width < 0.0 then
      TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "BoxZone requires a width (must be a positive number)!"}
      })
      return
    end
    
    boxStart(name, 0, length, width)
  else
    return
  end
  createdZoneType = zoneType
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:pzfinish")
AddEventHandler("polyzone:pzfinish", function()
  if createdZone == nil then
    return
  end

  if createdZoneType == 'poly' then
    polyFinish()
  elseif createdZoneType == "circle" then
    circleFinish()
  elseif createdZoneType == "box" then
    boxFinish()
  end

  TriggerEvent('chat:addMessage', {
    color = { 0, 255, 0},
    multiline = true,
    args = {"Me", "Check your server root folder for polyzone_created_zones.txt to get the zone!"}
  })

  lastCreatedZoneType = createdZoneType
  lastCreatedZone = createdZone

  drawZone = false
  createdZone = nil
  createdZoneType = nil
end)

RegisterNetEvent("polyzone:pzlast")
AddEventHandler("polyzone:pzlast", function()
  if createdZone ~= nil or lastCreatedZone == nil then
    return
  end
  if lastCreatedZoneType == 'poly' then
    TriggerEvent('chat:addMessage', {
      color = { 0, 255, 0},
      multiline = true,
      args = {"Me", "The command pzlast only supports BoxZone and CircleZone for now"}
    })
  
  end

  createdZoneType = lastCreatedZoneType
  if createdZoneType == 'box' then
    boxStart(lastCreatedZone.name, lastCreatedZone.offsetRot, lastCreatedZone.length, lastCreatedZone.width)
  elseif createdZoneType == 'circle' then
    circleStart(lastCreatedZone.name, lastCreatedZone.radius)
  end
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:pzcancel")
AddEventHandler("polyzone:pzcancel", function()
  if createdZone == nil then
    return
  end

  TriggerEvent('chat:addMessage', {
    color = {255, 0, 0},
    multiline = true,
    args = {"Me", "Zone creation canceled!"}
  })

  drawZone = false
  createdZone = nil
  createdZoneType = nil
end)

-- Drawing
function drawThread()
  Citizen.CreateThread(function()
    while drawZone do
      if createdZone then
        createdZone:draw()
      end
      Wait(0)
    end
  end)
end