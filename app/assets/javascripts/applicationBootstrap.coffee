$ ->
  do setTopLevelLayout
  do initializeMap

setTopLevelLayout = ->
  lite = 
    resizable: false
    slidable: false
    closable: false
    spacing_open: false
  $("body").layout {defaults: lite}
  $("#app_page").layout {north: lite}

initializeMap = ->
  map = new OpenLayers.Map("open_layers_map")
  ol_wms = new OpenLayers.Layer.WMS("OpenLayers WMS", "http://vmap0.tiles.osgeo.org/wms/vmap0", {layers: "basic"})
  map.addLayers([ol_wms])
  map.zoomToMaxExtent()
