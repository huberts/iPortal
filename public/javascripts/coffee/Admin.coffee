PORTAL.Admin = {}

PORTAL.activateAdmin = ->
  $(".layer-remove").click -> PORTAL.Admin.deleteLayer $(this)
  $(".source-remove").click -> PORTAL.Admin.deleteSource $(this)
  $(".service-remove").click -> PORTAL.Admin.deleteService $(this)

PORTAL.Admin.deleteSource = (element)->
  parts = element.attr("id")?.split "-"
  srcId =  parts[1]
  $.ajax {
    type: "DELETE",
    url: "admin/deleteSource",
    data: "id="+srcId,
    success: (data) ->
      PORTAL.Handlers.removeSource element
  }

PORTAL.Admin.deleteService = (element)->
  parts = element.attr("id")?.split "-"
  wmsId =  parts[2]
  $.ajax {
    type: "DELETE",
    url: "admin/deleteService",
    data: "id="+wmsId,
    success: (data) ->
      PORTAL.Handlers.removeWms element
  }

PORTAL.Admin.deleteLayer = (element)->
  parts = element.attr("id")?.split "-"
  layerId =  parts[3]
  $.ajax {
    type: "DELETE",
    url: "admin/deleteLayer",
    data: "id="+layerId,
    success: (data) ->
      PORTAL.Handlers.removeLayer element
  }
