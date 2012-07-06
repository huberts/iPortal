PORTAL.Admin = {}

PORTAL.activateAdmin = ->
  do activateEditModal
  do activateLocationsTree
  do activateLocationsModal
  do activateLayersSortSave

  $(".layer-default").click -> PORTAL.Admin.defaultLayer $(this)

  $(".layer-remove").click -> PORTAL.Admin.deleteLayer $(this)
  $(".source-remove").click -> PORTAL.Admin.deleteSource $(this)
  $(".service-remove").click -> PORTAL.Admin.deleteService $(this)
  $(".location-remove").click -> PORTAL.Admin.deleteLocation $(this)

  $(".layer-edit").click -> PORTAL.Admin.editLayer $(this)
  $(".source-edit").click -> PORTAL.Admin.editSource $(this)
  $(".service-edit").click -> PORTAL.Admin.editService $(this)
  $(".location-edit").click -> PORTAL.Admin.editLocation $(this)

activateEditModal = ->
  $("#adminEditModal").on "shown", ->
    $("#adminEditModal .modal-footer a").attr "disabled", !canSaveEdit()
  $("#adminEditName").on "input", ->
    $("#adminEditName .modal-footer a").attr "disabled", !canSaveEdit()

canSaveEdit = -> $("#adminEditName").val().length

activateLocationsTree = ->
  $("#locations h3, #locations h4, #locations i.icon-plus, #locations i.icon-minus").click -> PORTAL.Handlers.treeClick $(this)
  $("#locations button").click -> setMapOnLocation $(this)
  $(".location-set").click -> PORTAL.Admin.setLocation $(this)

setMapOnLocation = (element) ->
  coordinates = element.val().split "|"
  PORTAL.map.setCenter new OpenLayers.LonLat(coordinates[1], coordinates[0]), coordinates[2]

activateLocationsModal = ->
  $(".addLocation").click -> PORTAL.Admin.addLocation $(this)
  $("#adminAddLocationModal").on "shown", ->
    $("#adminAddLocationModalName .modal-footer a").attr "disabled", !canAddLocation()
  $("#adminAddLocationModal").on "input", ->
    $("#adminAddLocationModalName .modal-footer a").attr "disabled", !canAddLocation()

canAddLocation = -> $("#adminAddLocationModalName").val().length

activateLayersSortSave = ->
  $("#app_layers, #app_layers .tier1_content, #app_layers .tier2_content").bind "sortupdate", sortLayersSave

sortLayersSave = ->
  listOfLayers = []
  $("#app_layers .tier3 input").each (i, e) ->
    listOfLayers.push {
      id: parseInt($(this).attr("id").split("-")[3]),
      sort: i
    }
  $.ajax {
    type: "PUT",
    url: "admin/orderLayers",
    data: {listOfLayers: listOfLayers}
  }

PORTAL.Admin.addLocation = (element) ->
  parentId = element.data("id")
  $("#adminAddLocationModalName").val ""
  $("#adminAddLocationModal .modal-footer a").off("click").on "click", ->
    if canAddLocation()
      $("#addLocationModal .modal-footer a").attr "disabled", true
      name = $("#adminAddLocationModalName").val()
      xCoordinate = PORTAL.map.getCenter().lat.toFixed(0)
      yCoordinate = PORTAL.map.getCenter().lon.toFixed(0)
      zoomLevel = PORTAL.map.getZoom()
      $.ajax {
        type: "POST",
        url: "admin/addLocation",
        data: {name: name, xCoordinate: xCoordinate, yCoordinate: yCoordinate, zoomLevel: zoomLevel, parentId: parentId},
        success: (result) ->
          parent = element.parent()
          tierLevel = if parent.hasClass("tier1_content") then 2 else 1
          tier = $("<div/>", {class: "tier"+tierLevel})
          tierHeader = $("<div/>", {class: "tier"+tierLevel+"_header clearfix"})
          plus = $("<i/>", {id: "location-"+result.id, class: "icon-minus icon-white hide"})
          button = $("<button/>", {
            class: "btn btn-mini btn-primary",
            type: "button",
            value: xCoordinate+"|"+yCoordinate+"|"+zoomLevel,
            click: -> setMapOnLocation $(this)
          })
          arrow = $("<i/>", {class: "icon-arrow-right icon-white"})
          h = $("<h"+String(2+tierLevel)+"/>", {html: name})
          pull_right = $("<div/>", {class: "pull-right"})
          set = $("<i/>", {
            class: "location-set icon-white icon-globe",
            "data-id" : result.id,
            click: -> PORTAL.Admin.setLocation $(this)
          })
          edit = $("<i/>", {
            class: "location-edit icon-white icon-pencil",
            "data-id" : result.id,
            click: -> PORTAL.Admin.editLocation $(this)
          })
          remove = $("<i/>", {
            class: "location-remove icon-white icon-remove",
            "data-id" : result.id,
            click: -> PORTAL.Admin.deleteLocation $(this)
          })
          if tierLevel == 1
            tierContent = $("<div/>", {class: "tier"+tierLevel+"_content well"})
            addButton = $("<button/>", {
              html: element.text(),
              class: "btn addLocation",
              type: "button",
              "data-id": result.id,
              click: -> PORTAL.Admin.addLocation $(this)
            })
            tierContent.append(addButton)

          tierHeader.append(plus).append(button.append(arrow)).append(" ").append(h)
          tierHeader.append(pull_right.append(set).append(" ").append(edit).append(" ").append(remove))
          parent.append(tier.append(tierHeader).append(tierContent))
          $("#adminAddLocationModal").modal "hide"
      }
  $("#adminAddLocationModal").modal 'show'

PORTAL.Admin.setLocation = (element) ->
  locationId = element.data("id")
  xCoordinate = PORTAL.map.getCenter().lat.toFixed(0)
  yCoordinate = PORTAL.map.getCenter().lon.toFixed(0)
  zoomLevel = PORTAL.map.getZoom()
  $.ajax {
    type: "PUT",
    url: "admin/editLocation",
    data: {id: locationId, xCoordinate: xCoordinate, yCoordinate: yCoordinate, zoomLevel: zoomLevel},
    success: (result) ->
      element.closest("button").val(xCoordinate+"|"+yCoordinate+"|"+zoomLevel)
  }

PORTAL.Admin.defaultLayer = (element) ->
  layerId = element.data("id")
  defaultVisible = !element.hasClass "icon-white"
  $.ajax {
    type: "PUT",
    url: "admin/editLayer",
    data: { id: layerId, defaultVisible: defaultVisible},
    success: (data) ->
      element.toggleClass "icon-white", defaultVisible
  }

PORTAL.Admin.deleteSource = (element) ->
  srcId = element.data("id")
  $.ajax {
    type: "DELETE",
    url: "admin/deleteSource",
    data: "id="+srcId,
    success: (data) ->
      PORTAL.Handlers.removeSource element
  }

PORTAL.Admin.deleteService = (element) ->
  wmsId = element.data("id")
  $.ajax {
    type: "DELETE",
    url: "admin/deleteService",
    data: "id="+wmsId,
    success: (data) ->
      PORTAL.Handlers.removeWms element
  }

PORTAL.Admin.deleteLayer = (element) ->
  layerId = element.data("id")
  $.ajax {
    type: "DELETE",
    url: "admin/deleteLayer",
    data: "id="+layerId,
    success: (data) ->
      PORTAL.Handlers.removeLayer element
  }

PORTAL.Admin.deleteLocation = (element) ->
  locationId = element.data("id")
  $.ajax {
    type: "DELETE",
    url: "admin/deleteLocation",
    data: "id="+locationId,
    success: (data) ->
      element.closest(".tier1, .tier2").hide "fast", -> $(this).remove()
  }

PORTAL.Admin.editSource = (element) ->
  srcId = element.data("id")
  treeTextItem = element.parent().siblings("div > h3,h4,label")
  $("#adminEditName").val treeTextItem.text()
  $("#adminEditModal .modal-footer a").off("click").on "click", ->
    if canSaveEdit()
      $("#adminEditModal .modal-footer a").attr "disabled", true
      name = $("#adminEditName").val()
      $.ajax {
        type: "PUT",
        url: "admin/editSource",
        data: {id: srcId, name: name},
        success: (result) ->
          treeTextItem.text name
          $("#adminEditModal").modal "hide"
      }
  $("#adminEditModal").modal 'show'

PORTAL.Admin.editService = (element) ->
  wmsId = element.data("id")
  treeTextItem = element.parent().siblings("h3,h4,label")
  $("#adminEditName").val treeTextItem.text()
  $("#adminEditModal .modal-footer a").off("click").on "click", ->
    if canSaveEdit()
      $("#adminEditModal .modal-footer a").attr "disabled", true
      name = $("#adminEditName").val()
      $.ajax {
        type: "PUT",
        url: "admin/editService",
        data: {id: wmsId, name: name},
        success: (result) ->
          treeTextItem.text name
          $("#adminEditModal").modal "hide"
      }
  $("#adminEditModal").modal 'show'

PORTAL.Admin.editLayer = (element) ->
  layerId = element.data("id")
  treeTextItem = element.parent().siblings("h3,h4,label")
  $("#adminEditName").val treeTextItem.text()
  $("#adminEditModal .modal-footer a").off("click").on "click", ->
    if canSaveEdit()
      $("#adminEditModal .modal-footer a").attr "disabled", true
      name = $("#adminEditName").val()
      $.ajax {
        type: "PUT",
        url: "admin/editLayer",
        data: {id: layerId, name: name},
        success: (result) ->
          treeTextItem.text name
          $("#adminEditModal").modal "hide"
      }
  $("#adminEditModal").modal 'show'

PORTAL.Admin.editLocation = (element) ->
  locationId = element.data("id")
  treeTextItem = element.parent().siblings("h3,h4,label")
  $("#adminEditName").val treeTextItem.text()
  $("#adminEditModal .modal-footer a").off("click").on "click", ->
    if canSaveEdit()
      $("#adminEditModal .modal-footer a").attr "disabled", true
      name = $("#adminEditName").val()
      $.ajax {
        type: "PUT",
        url: "admin/editLocation",
        data: {id: locationId, name: name},
        success: (result) ->
          treeTextItem.text name
          $("#adminEditModal").modal "hide"
      }
  $("#adminEditModal").modal 'show'