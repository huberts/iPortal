PORTAL.Layers.registerWms = (srcId) ->
  newWmsId = getWmsCount srcId + 1
  setTimeout (-> PORTAL.Layers.doAddNewWms srcId, newWmsId), 600

getWmsCount = (srcId) ->
  $('#toggler-'+srcId).parent().parent().children(".tier1_content").children(".tier2").length

PORTAL.Layers.addOLLayers = (srcId, wmsId) ->
  layers = []
  layers.push {'id': i, 'name': layer.name, 'displayName': layer.title} for layer, i in PORTAL.Layers.getLayerNames()
  PORTAL.Layers.doAddLayersView srcId, wmsId, layers
