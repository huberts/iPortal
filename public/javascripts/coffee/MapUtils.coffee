PORTAL.Utils = {}


PORTAL.Utils.addLayer = (layer) ->
  olLayer = new OpenLayers.Layer.WMS(layer.displayName, layer.serviceUrl,
    {layers: layer.name, transparent: true},
    {visibility: false, singleTile: true, ratio: 1.0, buffer: 1, transitionEffect: "resize"}
  )
  olLayer.id = "layer-" + layer.index;
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


