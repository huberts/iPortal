PORTAL.createControllers = ->

  PORTAL.map.addControl new OpenLayers.Control.Scale "open_layers_status_scale", {
    div:
      OpenLayers.Util.getElement "open_layers_status_scale"
    updateScale:
      -> this.element.innerHTML = OpenLayers.i18n "Scale = 1 : ${scaleDenom}", {'scaleDenom': Math.round this.map.getScale()}
  }


  PORTAL.map.addControl new OpenLayers.Control.ScaleLine {
    div:
      OpenLayers.Util.getElement "open_layers_status_scaleline"
    bottomInUnits:
      ""
    bottomOutUnits:
      ""
  }


  PORTAL.map.addControl new OpenLayers.Control.MousePosition {
    div:
      OpenLayers.Util.getElement "open_layers_status_coords_map"
    emptyString:
      "współrzędne (szer./dł.)"
    formatOutput:
      (lonLat) -> OpenLayers.AppUtils.getFormattedLonLat(lonLat.lat, 'lat') + " " + OpenLayers.AppUtils.getFormattedLonLat(lonLat.lon, 'lon')
  }


  PORTAL.map.addControl new OpenLayers.Control.MousePosition {
    div:
      OpenLayers.Util.getElement "open_layers_status_coords_lonlat"
    emptyString:
      "współrzędne (1992)"
    prefix:
      "X: "
    separator:
      " Y: "
    displayProjection:
      PORTAL.map.projection
    numDigits:
      2
    formatOutput:
      (lonLat) -> this.prefix + lonLat.lat.toFixed(parseInt this.numDigits) + this.separator + lonLat.lon.toFixed(parseInt this.numDigits)
  }


  PORTAL.map.addControl new OpenLayers.Control.PanZoomBar


  PORTAL.map.addControl new OpenLayers.Control.Navigation {
    zoomBoxEnabled:
      true
    zoomWheelEnabled:
      true
  }


  PORTAL.map.addControls [PORTAL.zoomIn, PORTAL.zoomOut]

  $("#open_layers_button_extent").click ->
    PORTAL.map.zoomToMaxExtent()

  $("#open_layers_button_zoom_in").click ->
    $(this).toggleClass "active"
    if $(this).hasClass "active"
      $("#open_layers_button_zoom_out").removeClass "active"
      PORTAL.zoomOut.deactivate()
      PORTAL.zoomIn.activate()
    else
      PORTAL.zoomIn.deactivate()

  $("#open_layers_button_zoom_out").click ->
    $(this).toggleClass "active"
    if $(this).hasClass "active"
      $("#open_layers_button_zoom_in").removeClass "active"
      PORTAL.zoomIn.deactivate()
      PORTAL.zoomOut.activate()
    else
      PORTAL.zoomOut.deactivate()


  $("#open_layers_button_extent").tooltip {
    title: PORTAL.messages.zoomToExtent,
    placement: "bottom"
  }
  $("#open_layers_button_zoom_in").tooltip {
    title: PORTAL.messages.zoomIn,
    placement: "bottom"
  }
  $("#open_layers_button_zoom_out").tooltip {
    title: PORTAL.messages.zoomOut,
    placement: "bottom"
  }
