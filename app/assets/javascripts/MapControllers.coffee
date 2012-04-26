window.createControllers = ->
  window.map.addControl new OpenLayers.Control.AppScale "open_layers_status_scale"
  window.map.addControl new OpenLayers.Control.AppMouseMapPosition "open_layers_status_coords_map"
  window.map.addControl new OpenLayers.Control.AppMouseLonLatPosition "open_layers_status_coords_lonlat"




