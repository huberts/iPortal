PORTAL.Layers = {}
PORTAL.Layers.list = [];

PORTAL.activateLayers = ->
  $("#addWmsLayerFailure").hide()
  $("#addWmsModalLoadLayers").click -> loadLayers()
  $(".service-add").click -> PORTAL.Layers.addNewWms $(this)
  $("#app_layers .tier2_header > button").click -> setMapOnLocation $(this)
  $("#addWmsModal").on "show", ->
    $("#addWmsModal .modal-footer a").attr "disabled", !canAddWms()
  $("#addWmsModal").on "hidden", ->
    $("#addWmsLayerFailure").hide()

loadLayers = ->
  $("#addWmsModalLoadLayers").attr "disabled", true
  priv.clearLayersSection()
  OpenLayers.Request.GET {
    url: priv.getGetCapabilitiesUrl()
    success: priv.layersLoaded
    failure: priv.layersLoadingFailure
  }

PORTAL.Layers.addNewWms = (element) ->
  srcId = element.data("id")
  $("#addWmsModal .modal-footer a").off("click").on "click", ->
    if canAddWms()
      hideModal()
      PORTAL.Layers.registerWms srcId
  $("#addWmsModal").modal 'show'

canAddWms = -> $("#addWmsModalVisibleName").val().length && $("#addWmsModalUrl").val().length && PORTAL.Layers.getLayerNames().length

hideModal = -> $("#addWmsModal").modal "hide"

PORTAL.Layers.doAddNewWms = (srcId, wmsId) ->
  addWmsView srcId, wmsId
  PORTAL.Layers.addOLLayers srcId, wmsId

addWmsView = (srcId, wmsId) ->
  wmsVisibleName = $("#addWmsModalVisibleName").val()

  tier2 = $("<div/>", {class: "tier2"})
  tier2Header = $("<div/>", {class: "tier2_header clearfix"})
  plus = $("<i/>", {class: "icon-plus icon-white", click: -> PORTAL.Handlers.treeClick $(this)})
  input = $("<input/>", {id: "toggler-"+srcId+"-"+wmsId, type: "checkbox", class: "wms-toggler", change: -> PORTAL.Handlers.wmsToggled $(this)})
  button = $("<button/>", {class: "btn btn-mini btn-primary", type: "button", click: -> setMapOnLocation $(this)})
  arrow = $("<i/>", {class: "icon-arrow-right icon-white"})
  h4 = $("<h4/>", {html: wmsVisibleName, click: -> PORTAL.Handlers.treeClick $(this)})
  pull_right = $("<div/>", {class: "pull-right"})
  remove = $("<i/>", {class: "service-remove icon-remove icon-white", "data-id": wmsId , click: -> PORTAL.Handlers.removeWms $(this)})
  tier2Content = $("<div/>", {class: "tier2_content"})
  PORTAL.Handlers.sort tier2Content

  tier2Header.append(plus).append(" ").append(input).append(" ").append(button.append(arrow)).append(" ").append(h4).append(pull_right.append(remove))
  tier2.append(tier2Header).append(tier2Content)
  $('#toggler-' + srcId).parent().parent().children(".tier1_content").append tier2

setMapOnLocation = (element) ->
  coordinates = element.val().split "|"
  PORTAL.map.setCenter new OpenLayers.LonLat(coordinates[1], coordinates[0]), coordinates[2]

PORTAL.Layers.doAddLayersView = (srcId, wmsId, layers) ->
  elem = $('#toggler-'+srcId+'-'+wmsId).parent().parent().children(".tier2_content")
  elem.append createLayerView srcId, wmsId, layer.id, layer.displayName for layer in layers
  PORTAL.Utils.addLayer buildLayerObject srcId, wmsId, layer for layer in layers
  sortLayers()
  cleanUpModal()

PORTAL.Layers.getLayerNames = ->
  layerNames = []
  $("#addWmsLayerNames button").each ->
    if $(this).val().length && $(this).children("i").hasClass("icon-ok")
      layerNames.push { name: $(this).val(), title: $(this).siblings("span").text() }
  return layerNames

createLayerView = (srcId, wmsId, layerId, layerTitle) ->
  tier3 = $("<div/>", {class: "tier3"})
  tier3Content = $("<div/>", {class: "tier3_content clearfix"})
  input = $("<input/>", {id: "toggler-"+srcId+"-"+wmsId+"-"+layerId, type: "checkbox", class: "layer-toggler", change: -> PORTAL.Handlers.layerToggled $(this)})
  button = $("<span/>", {class: "btn btn-mini", "data-toggle": "button", html: "&middot; &middot; &middot;", click: -> PORTAL.Handlers.layerDetails $(this)})
  label = $("<label/>", {for: "toggler-"+srcId+"-"+wmsId+"-"+layerId, text: layerTitle})
  pull_right = $("<div/>", {class: "pull-right"})
  remove = $("<i/>", {class: "layer-remove icon-remove icon-white", "data-id": layerId, click: -> PORTAL.Handlers.removeLayer $(this)})
  details = $("<div/>", {class: "layer-details"})
  minus = $("<i/>", {class: "icon-minus-sign", click: -> PORTAL.Handlers.changeLayerOpacity $(this)})
  span = $("<span/>", {html: "100%"})
  plus = $("<i/>", {class: "icon-plus-sign", click: -> PORTAL.Handlers.changeLayerOpacity $(this)})
  details.append(minus).append(span).append(plus)
  tier3.append tier3Content.append(input).append(button).append(label).append(pull_right.append(remove)).append(details)

sortLayers = -> PORTAL.Utils.sortLayers()

buildLayerObject = (srcId, wmsId, layer) ->
  {
    serviceType: "WMS",
    name: layer.name,
    displayName: layer.displayName,
    serviceUrl: $("#addWmsModalUrl").val(),
    index: srcId+"-"+wmsId+"-"+layer.id,
    defaultVisible: true
  }

cleanUpModal = ->
  $("#addWmsModal input").val ""
  priv.clearLayersSection()

priv = {}

priv.clearLayersSection = ->
  $("#addWmsLayerFailure").hide "fast"
  $("#addWmsLayerNames").empty()

priv.getGetCapabilitiesUrl = ->
  uriComponent = $("#addWmsModalUrl").val().replace /\//g, PORTAL.configurationSettings.urlSlashReplacement
  "http://" + location.host + "/getCapabilities/" + encodeURIComponent uriComponent

priv.layersLoaded = (response) ->
  $("#addWmsModalLoadLayers").attr "disabled", false
  try
    $xml = $($.parseXML response.responseText)
    if !priv.hasMapProjection $xml
      throw "Invalid projection"
    priv.addLayers $xml
    $("#addWmsModal .modal-footer a").attr "disabled", false
  catch  e
    priv.layersLoadingFailure()

priv.hasMapProjection = (xml) ->
  hasProjection = false
  xml.find("CRS,SRS").each (i,srs) ->
    if $(srs).text()==PORTAL.map.getProjection()
      hasProjection = true
  hasProjection

priv.addLayers = (xml) ->
  xml.find("Layer").each (i,layer) ->
    if priv.isQueryable layer
      priv.addLayer layer

priv.isQueryable = (layer) ->
  $(layer).attr("queryable")=="1"

priv.addLayer = (layer) ->
  name = $(layer).children("Name").text()
  title = $(layer).children("Title").text()
  div = $("<div/>")
  span = $("<span/>", { html: title ? name })
  button = $("<button/>", { class: "own-layer-name btn btn-mini", type: "button", value: name, click: -> PORTAL.Handlers.checkLayerToAdd $(this) })
  icon = $("<i/>", { class: "icon-ok" })
  $("#addWmsLayerNames").append(div.append(span, button.append(icon)))

priv.layersLoadingFailure = ->
  $("#addWmsModalLoadLayers").attr "disabled", false
  $("#addWmsLayerFailure").show "fast"
