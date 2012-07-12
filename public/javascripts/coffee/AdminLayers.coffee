PORTAL.Layers.registerWms = (srcId) ->
  $.ajax {
    type: "POST",
    url: "admin/addService",
    data: {name: $("#addWmsModalVisibleName").val(), url: $("#addWmsModalUrl").val(), type: 'WMS', sourceId: srcId},
    success: (data) ->
      if data.id?
        PORTAL.Layers.doAddNewWms srcId, data.id
        $("#toggler-"+srcId+"-"+data.id).parents(".tier2_header").find(".pull-right > i.service-remove").on "click", -> PORTAL.Admin.deleteService $(this)
        edit = $("<i/>", {
          class: "service-edit icon-white icon-pencil",
          "data-id" : data.id,
          click: -> PORTAL.Admin.editService $(this)
        })
        set = $("<i/>", {
          class: "service-set icon-white icon-globe",
          "data-id" : data.id,
          click: -> PORTAL.Admin.setService $(this)
        })
        $("#toggler-"+srcId+"-"+data.id).parents(".tier2_header").find(".pull-right").prepend(" ").prepend(edit).prepend(" ").prepend(set)
  }

PORTAL.Layers.addOLLayers = (srcId, wmsId) ->
  layers = []
  layers.push {'mapService.id': ''+wmsId, 'name': layer.name, 'displayName': layer.title, 'defaultVisible': true} for layer in PORTAL.Layers.getLayerNames()
  $.ajax {
    type: "POST",
    url: "admin/addLayers",
    data: {'layer': layers},
    success: (result) ->
      PORTAL.Layers.doAddLayersView srcId, wmsId, result
      $.each result, (i, layer) ->
        $("#toggler-"+srcId+"-"+wmsId+"-"+layer.id).parents(".tier3_content").find(".pull-right > i.layer-remove").on "click", -> PORTAL.Admin.deleteLayer $(this)
        edit = $("<i/>", {
          class: "layer-edit icon-white icon-pencil",
          "data-id" : layer.id,
          click: -> PORTAL.Admin.editLayer $(this)
        })
        defaultVisible = $("<i/>", {
          class: "layer-default icon-white icon-eye-open",
          "data-id": layer.id,
          click: -> PORTAL.Admin.defaultLayer $(this)
        })
        $("#toggler-"+srcId+"-"+wmsId+"-"+layer.id).parents(".tier3_content").find(".pull-right").prepend(" ").prepend(edit).prepend(" ").prepend(defaultVisible)
  }
