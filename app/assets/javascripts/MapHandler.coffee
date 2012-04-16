window.prepareMap = ->
  do createProjections
  do createMap
  do createLayersSwitcher
  do finish


createProjections = ->
  Proj4js.defs['EPSG:2180'] = '+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs';
  Proj4js.defs["EPSG:2177"] = '+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs';
  window.epsg2177 = new OpenLayers.Projection('EPSG:2177');
  window.epsg2180 = new OpenLayers.Projection('EPSG:2180');
  window.epsg4326 = new OpenLayers.Projection('EPSG:4326');


createMap = ->
  window.map = new OpenLayers.Map "open_layers_map", {
    allOverlays: true,
    projection: window.epsg2180,
    maxExtent: new OpenLayers.Bounds(508000, 380000, 525000, 404000)
  }


createLayersSwitcher = ->
  addLayer layer for layer in window.layers
  do activateToggleButtons


addLayer = (layer) ->
  olLayer = new OpenLayers  .Layer.WMS(layer.visibleName, layer.serviceUrl,
    {layers: layer.name, transparent: true},
    {visibility: false}
  )
  olLayer.id = "layer-" + layer.index;
  window.map.addLayer olLayer


activateToggleButtons = ->
  $("button.layer-toggler").click( ->
    $(this).button "toggle"
    layer = findLayer buildIdWithPrefix $(this).attr("id"), "layer"
    if layer==null
      return
    layer.setVisibility $(this).hasClass "active"
  )

findLayer = (id) ->
  layers = (layer for layer in window.map.layers when layer.id==id)
  if layers.empty
    return null
  else
    return layers[0]


buildIdWithPrefix = (id, prefix) ->
  parts = id.split "-"
  parts[0] = prefix
  return parts.join "-"

finish = ->
  window.map.zoomToMaxExtent()
