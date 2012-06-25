PORTAL.activateOwnLayers = ->
  $("#addWmsLayerFailure").hide()
  $("#addWmsModalLoadLayers").click -> loadLayers()
  $("#addWmsModal .modal-footer a").click -> addNewWms()
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


addNewWms = ->
  if canAddWms()
    hideModal()
    setTimeout doAddNewWms, 600

doAddNewWms = ->
  id = $("#addWmsModal").data('modal').options.id
  wmsNumber = $('#toggler-' + id).parent().parent().children(".tier1_content").children(".tier2").length + 1
  addWmsView(id, wmsNumber)
  addOLLayers(id, wmsNumber)
  sortLayers()
  cleanUpModal()


priv = {}

canAddWms = -> $("#addWmsModalVisibleName").val().length && $("#addWmsModalUrl").val().length && getLayerNames().length

addWmsView = (id, wmsNumber) ->
  wmsVisibleName = $("#addWmsModalVisibleName").val()

  tier2 = $("<div/>", {class: "tier2"})
  tier2Header = $("<div/>", {class: "tier2_header clearfix"})
  plus = $("<i/>", {class: "icon-plus icon-white", click: -> PORTAL.Handlers.treeClick $(this)})
  input = $("<input/>", {id: "toggler-"+id+"-"+wmsNumber, type: "checkbox", class: "wms-toggler", change: -> PORTAL.Handlers.wmsToggled $(this)})
  h4 = $("<h4/>", {html: wmsVisibleName, click: -> PORTAL.Handlers.treeClick $(this)})
  pull_right = $("<div/>", {class: "pull-right"})
  remove = $("<i/>", {class: "icon-remove icon-white", click: -> PORTAL.Handlers.removeWms $(this)})
  tier2Content = $("<div/>", {class: "tier2_content"})
  PORTAL.Handlers.sort tier2Content
  layers = (createLayerView id, wmsNumber, layer.title, i for layer, i in getLayerNames())

  tier2Content.append layer for layer in layers
  tier2Header.append(plus).append(" ").append(input).append(" ").append(h4).append(pull_right.append(remove))
  tier2.append(tier2Header).append(tier2Content)
  $('#toggler-' + id).parent().parent().children(".tier1_content").append tier2

hideModal = -> $("#addWmsModal").modal "hide"

addOLLayers = (id, wmsNumber)-> PORTAL.Utils.addLayer buildLayerObject(id, wmsNumber, layer,i) for layer,i in getLayerNames()

sortLayers = -> PORTAL.Utils.sortLayers()

buildLayerObject = (id, wmsNumber, layer, index) ->
  {
    serviceType: "WMS",
    name: layer.name,
    displayName: layer.title,
    serviceUrl: $("#addWmsModalUrl").val(),
    index: id+"-"+wmsNumber+"-"+index,
    defaultVisible: true
  }

getLayerNames = ->
  layerNames = []
  $("#addWmsLayerNames button").each ->
    if $(this).val().length && $(this).children("i").hasClass("icon-ok")
      layerNames.push { name: $(this).val(), title: $(this).siblings("span").text() }
  return layerNames

createLayerView = (id, wmsNumber, layerTitle, layerNumber) ->
  tier3 = $("<div/>", {class: "tier3"})
  tier3Content = $("<div/>", {class: "tier3_content"})
  input = $("<input/>", {id: "toggler-"+id+"-"+wmsNumber+"-"+layerNumber, type: "checkbox", class: "layer-toggler", change: -> PORTAL.Handlers.layerToggled $(this)})
  button = $("<span/>", {class: "btn btn-mini", "data-toggle": "button", html: "&middot; &middot; &middot;", click: -> PORTAL.Handlers.layerDetails $(this)})
  label = $("<label/>", {for: "toggler-"+id+"-"+wmsNumber+"-"+layerNumber, text: layerTitle})
  details = $("<div/>", {class: "layer-details"})
  minus = $("<i/>", {class: "icon-minus-sign", click: -> PORTAL.Handlers.changeLayerOpacity $(this)})
  span = $("<span/>", {html: "100%"})
  plus = $("<i/>", {class: "icon-plus-sign", click: -> PORTAL.Handlers.changeLayerOpacity $(this)})
  details.append(minus).append(span).append(plus)
  tier3.append tier3Content.append(input).append(button).append(label).append(details)

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
