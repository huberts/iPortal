PORTAL.Layers.registerWms = (srcId) ->
  $.ajax {
    type: "PUT",
    url: "admin/addService",
    data: {name: $("#addWmsModalVisibleName").val(), url: $("#addWmsModalUrl").val(), type: 'WMS', sourceId: srcId},
    success: (data) ->
      if data.id?
        PORTAL.Layers.doAddNewWms srcId, data.id
        $("#toggler-"+srcId+"-"+data.id).parents(".tier2_header").find(".pull-right > i").on "click", -> PORTAL.Admin.deleteService $(this)
  }

PORTAL.Layers.addOLLayers = (srcId, wmsId) ->
  layers = []
  layers.push {'mapService.id': ''+wmsId, 'name': layer.name, 'displayName': layer.title} for layer in PORTAL.Layers.getLayerNames()
  $.ajax {
    type: "POST",
    url: "admin/addLayers",
    data: {'layer': layers},
    success: (result) ->
      PORTAL.Layers.doAddLayersView srcId, wmsId, result
      $("#toggler-"+srcId+"-"+wmsId+"-"+layer.id).parents(".tier3_content").find(".pull-right > i").on("click", -> PORTAL.Admin.deleteLayer $(this)) for layer in result
  }
