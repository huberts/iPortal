PORTAL.Layers.registerWms = (srcId) ->
  $.ajax {
    type: "POST",
    url: "admin/addService",
    data: {name: $("#addWmsModalVisibleName").val(), url: $("#addWmsModalUrl").val(), typeId: 1, sourceId: srcId},
    success: (data) ->
      if data.id
        PORTAL.Layers.doAddNewWms srcId, data.id
  }

PORTAL.Layers.addOLLayers = (srcId, wmsId) ->
  layers = []
  layers.push {'mapService.id': ''+wmsId, 'name': layer.name, 'displayName': layer.title} for layer in PORTAL.Layers.getLayerNames()
  $.ajax {
    type: "POST",
    url: "admin/addLayers",
    data: {'layer': layers},
    success: (result) -> PORTAL.Layers.doAddLayersView srcId, wmsId, result
  }
