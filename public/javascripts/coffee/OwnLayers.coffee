PORTAL.activateOwnLayers = ->
  $("#addWmsModalLoadLayers").click -> loadLayers()
  $("#addWmsModal .modal-footer a").click -> addNewWms()


loadLayers = ->
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
  addWmsView()
  addOLLayers()
  sortLayers()
  cleanUpModal()


priv = {}

priv.wmsNumber = 0

canAddWms = -> $("#addWmsModalVisibleName").val().length && $("#addWmsModalUrl").val().length && getLayerNames().length

addWmsView = ->
  priv.wmsNumber += 1
  wmsVisibleName = $("#addWmsModalVisibleName").val()

  tier2 = $("<div/>", {class: "tier2"})
  tier2Header = $("<div/>", {class: "tier2_header"})
  plus = $("<i/>", {class: "icon-plus icon-white", click: -> PORTAL.Handlers.treeClick $(this)})
  input = $("<input/>", {id: "toggler-0-"+priv.wmsNumber, type: "checkbox", class: "wms-toggler", change: -> PORTAL.Handlers.wmsToggled $(this)})
  h4 = $("<h4/>", {html: wmsVisibleName, click: -> PORTAL.Handlers.treeClick $(this)})
  remove = $("<i/>", {class: "icon-remove icon-white", click: -> PORTAL.Handlers.removeWms $(this)})
  tier2Content = $("<div/>", {class: "tier2_content"})
  PORTAL.Handlers.sort tier2Content
  layers = (createLayerView layer.title, i for layer, i in getLayerNames())

  tier2Content.append layer for layer in layers
  tier2Header.append(plus).append(input).append(h4).append(remove)
  tier2.append(tier2Header).append(tier2Content)
  $("#addWmsButton").parent().prepend tier2

hideModal = -> $("#addWmsModal").modal "hide"

addOLLayers = -> PORTAL.Utils.addLayer buildLayerObject(layer,i) for layer,i in getLayerNames()

sortLayers = -> PORTAL.Utils.sortLayers()

buildLayerObject = (layer, index) ->
  {
    serviceType: "WMS",
    name: layer.name,
    displayName: layer.title,
    serviceUrl: $("#addWmsModalUrl").val(),
    index: "0-"+priv.wmsNumber+"-"+index,
    defaultVisible: true
  }

getLayerNames = ->
  layerNames = []
  $("#addWmsLayerNames button").each ->
    if $(this).val().length && $(this).children("i").hasClass("icon-ok")
      layerNames.push { name: $(this).val(), title: $(this).siblings("span").text() }
  return layerNames

createLayerView = (layerTitle, layerNumber) ->
  tier3 = $("<div/>", {class: "tier3"})
  tier3Content = $("<div/>", {class: "tier3_content"})
  input = $("<input/>", {id: "toggler-0-"+priv.wmsNumber+"-"+layerNumber, type: "checkbox", class: "layer-toggler", change: -> PORTAL.Handlers.layerToggled $(this)})
  button = $("<span/>", {class: "btn btn-mini", "data-toggle": "button", html: "&middot; &middot; &middot;", click: -> PORTAL.Handlers.layerDetails $(this)})
  label = $("<label/>", {for: "toggler-0-"+priv.wmsNumber+"-"+layerNumber, text: layerTitle})
  details = $("<div/>", {class: "layer-details"})
  minus = $("<i/>", {class: "icon-minus-sign", click: -> PORTAL.Handlers.changeLayerOpacity $(this)})
  span = $("<span/>", {html: "100%"})
  plus = $("<i/>", {class: "icon-plus-sign", click: -> PORTAL.Handlers.changeLayerOpacity $(this)})
  details.append(minus).append(span).append(plus)
  tier3.append tier3Content.append(input).append(button).append(label).append(details)

cleanUpModal = ->
  $("#addWmsModal i.icon-remove").parent().remove()
  $("#addWmsModal input").val ""



priv = {}

priv.clearLayersSection = ->
  $("#addWmsLayerFailure").css "display", "none"
  $("#addWmsLayerNames").empty()

priv.getGetCapabilitiesUrl = ->
  "http://" + location.host + "/getCapabilities/" + encodeURIComponent( $("#addWmsModalUrl").val() )

priv.layersLoaded = (response) ->
  $xml = $($.parseXML((new XMLSerializer()).serializeToString(response.responseXML)))
  if priv.hasMapProjection $xml
    priv.addLayers $xml

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
  $("#addWmsLayerFailure").css "display", "block"
