window.createControllers = ->

  window.map.addControl new OpenLayers.Control.Scale "open_layers_status_scale", {
    div:
      OpenLayers.Util.getElement "open_layers_status_scale"
    updateScale:
      -> this.element.innerHTML = OpenLayers.i18n "Scale = 1 : ${scaleDenom}", {'scaleDenom': Math.round this.map.getScale()}
  }


  window.map.addControl new OpenLayers.Control.ScaleLine {
    div:
      OpenLayers.Util.getElement "open_layers_status_scaleline"
    bottomInUnits:
      ""
    bottomOutUnits:
      ""
  }


  window.map.addControl new OpenLayers.Control.MousePosition {
    div:
      OpenLayers.Util.getElement "open_layers_status_coords_map"
    emptyString:
      "współrzędne (szer./dł.)"
    formatOutput:
      (lonLat) -> OpenLayers.AppUtils.getFormattedLonLat(lonLat.lat, 'lat') + " " + OpenLayers.AppUtils.getFormattedLonLat(lonLat.lon, 'lon')
  }


  window.map.addControl new OpenLayers.Control.MousePosition {
    div:
      OpenLayers.Util.getElement "open_layers_status_coords_lonlat"
    emptyString:
      "współrzędne (1992)"
    prefix:
      "X: "
    separator:
      " Y: "
    displayProjection:
      window.map.projection
    numDigits:
      2
    formatOutput:
      (lonLat) -> this.prefix + lonLat.lat.toFixed(parseInt this.numDigits) + this.separator + lonLat.lon.toFixed(parseInt this.numDigits)
  }

  window.map.addControl new OpenLayers.Control.PanZoomBar {
    zoomWorldIcon: true
  }

  window.map.addControl new OpenLayers.Control.Navigation {
    zoomBoxEnabled:
      true
    zoomWheelEnabled:
      true
  }

