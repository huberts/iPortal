PORTAL.activateAdminSettings = ->
  do activateInitialMap


activateInitialMap = ->
  $(".initial-showlocation").click ->
    PORTAL.map.setCenter(
      new OpenLayers.LonLat(PORTAL.configurationSettings.mapInitialY, PORTAL.configurationSettings.mapInitialX), PORTAL.configurationSettings.mapInitialZ
    )
  $(".initial-setlocation").click ->
    xCoordinate = PORTAL.map.getCenter().lat.toFixed(0)
    yCoordinate = PORTAL.map.getCenter().lon.toFixed(0)
    zoomLevel = PORTAL.map.getZoom()
    $.ajax {
      type: "PUT",
      url: "admin/changeInitialMap",
      data: {xCoordinate: xCoordinate, yCoordinate: yCoordinate, zoomLevel: zoomLevel},
      success: (result) ->
        PORTAL.configurationSettings.mapInitialX = xCoordinate
        PORTAL.configurationSettings.mapInitialY = yCoordinate
        PORTAL.configurationSettings.mapInitialZ = zoomLevel
    }
