PORTAL.Utils = {}


PORTAL.Utils.addLayer = (layer) ->
  olLayer = null
  if layer.serviceType=="WMS"
    olLayer = priv.addWMSLayer layer
  if layer.serviceType=="ARS"
    olLayer = priv.addARSLayer layer
  if olLayer==null
    return
  olLayer.id = priv.createLayerId layer
  PORTAL.map.addLayer olLayer
  if layer.defaultVisible==true
    $("#" + PORTAL.Utils.buildIdWithPrefix olLayer.id, "toggler").click()


PORTAL.Utils.removeLayer = (id) ->
  olLayer = PORTAL.Utils.findLayer id
  if olLayer!=null
    olLayer.destroy()


PORTAL.Utils.findLayer = (layerId) ->
  layers = (layer for layer in PORTAL.map.layers when layer.id==layerId)
  layers[0] ? null


PORTAL.Utils.sortLayers = ->
  listOfLayers = []
  layersCount = $("#app_layers .tier3 input").length
  $("#app_layers .tier3 input").each (i, e) ->
    layer = PORTAL.Utils.findLayer PORTAL.Utils.buildIdWithPrefix($(this).attr("id"), "layer")
    listOfLayers.push {
    layer: layer
    oldVisibility: layer.getVisibility(),
    newZIndex: layersCount - i - 1
    }
    layer.setVisibility false
  PORTAL.map.setLayerIndex layer.layer, layer.newZIndex for layer in listOfLayers
  layer.layer.setVisibility true for layer in listOfLayers when layer.oldVisibility==true


PORTAL.Utils.buildIdWithPrefix = (oldPrefixedId, newPrefix) ->
  parts = oldPrefixedId.split "-"
  parts[0] = newPrefix
  parts.join "-"

priv = {}

priv.addWMSLayer = (layer) ->
  new OpenLayers.Layer.WMS(
    layer.displayName,
    layer.serviceUrl,
    {layers: layer.name, transparent: true},
    priv.createWMSLayerOptions()
  )

priv.addARSLayer = (layer) ->
  new OpenLayers.Layer.ArsGeoportal(
    layer.displayName,
    "http://ars.geoportal.gov.pl/ARS/getTile.aspx?service=BDO&cs=EPSG2180&fileIDX=L${z}X${x}Y${y}.png",#PARAM
    priv.createARSLayerOptions layer
  )

priv.createLayerId = (layer) ->
  "layer-" + layer.index

priv.createWMSLayerOptions = ->
  options = priv.createCommonLayerOptions()
  options.singleTile = true
  options.ratio = 1.0
  options.buffer = 1
  return options

priv.createARSLayerOptions = (layer) ->
  options = priv.createCommonLayerOptions()
  options.zoomOffset = 0 #PARAM
  options.maxExtent = new OpenLayers.Bounds(0, 0, 1228800, 819200) #PARAM
  options.resolutions = [1600,800,400,200,100,50,25]#PARAM
  return options

priv.createCommonLayerOptions = ->
  {
  visibility: false,
  transitionEffect: "resize",
  opacityPercentage: 100
  }
