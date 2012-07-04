PORTAL.Layers.registerWms = (srcId) ->
  $.ajax {
    type: "POST",
    url: "admin/addService",
    data: {name: $("#addWmsModalVisibleName").val(), url: $("#addWmsModalUrl").val(), type: 'WMS', sourceId: srcId},
    success: (data) ->
      if data.id?
        PORTAL.Layers.doAddNewWms srcId, data.id
        $("#toggler-"+srcId+"-"+data.id).parents(".tier2_header").find(".pull-right > i").on "click", PORTAL.Admin.deleteService
        edit = $("<i/>", {
          id: "edit-"+srcId+"-"+data.id,
          class: "service-remove icon-white icon-pencil",
          "data-toggle": "modal",
          "data-target" : "#adminEditModal",
          "data-id" : srcId+"-"+data.id
        })
        $("#toggler-"+srcId+"-"+data.id).parents(".tier2_header").find(".pull-right").prepend(" ").prepend(edit)
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
        $("#toggler-"+srcId+"-"+wmsId+"-"+layer.id).parents(".tier3_content").find(".pull-right > i").on "click", PORTAL.Admin.deleteLayer
        edit = $("<i/>", {
          id: "edit-"+srcId+"-"+wmsId+"-"+layer.id,
          class: "layer-remove icon-white icon-pencil",
          "data-toggle": "modal",
          "data-target" : "#adminEditModal",
          "data-id" : srcId+"-"+wmsId+"-"+layer.id
        })
        defaultVisible = $("<i/>", {
          id: "default-"+srcId+"-"+wmsId+"-"+layer.id,
          class: "layer-default icon-white icon-eye-open",
          click: -> PORTAL.Admin.defaultLayer $(this)
        })
        $("#toggler-"+srcId+"-"+wmsId+"-"+layer.id).parents(".tier3_content").find(".pull-right").prepend(" ").prepend(edit).prepend(" ").prepend(defaultVisible)
  }
