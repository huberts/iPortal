PORTAL.activateOwnLayers = ->
  $("#addWmsModal .modal-body button").click -> addAdditionalLayer()
  $("#addWmsModal .modal-footer a").click -> addNewWms()


addAdditionalLayer = ->
  div = $("<div/>")
  input = $("<input/>", {class: "own-layer-name", type: "text", placeholder: PORTAL.messages.layerName})
  i = $("<i/>", {class: "icon-remove icon-white", click: -> $(this).parent().remove()})
  $("#addWmsLayerNames").append div.append(input).append(i)


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

canAddWms = -> $("#addWmsModalVisibleName").val().length && $("#addWmsModalUrl").val().length && getLayerNames().length

addWmsView = ->
  priv.wmsNumber = $("#addWmsButton").siblings().length
  wmsVisibleName = $("#addWmsModalVisibleName").val()

  tier2 = $("<div/>", {class: "tier2"})
  tier2Header = $("<div/>", {class: "tier2_header"})
  plus = $("<i/>", {class: "icon-plus icon-white", click: -> PORTAL.Handlers.treeClick $(this)})
  input = $("<input/>", {id: "toggler-0-"+priv.wmsNumber, type: "checkbox", class: "wms-toggler", change: -> PORTAL.Handlers.wmsToggled $(this)})
  h4 = $("<h4/>", {text: wmsVisibleName, click: -> PORTAL.Handlers.treeClick $(this)})
  remove = $("<i/>", {class: "icon-remove icon-white", click: -> PORTAL.Handlers.removeWms $(this)})
  tier2Content = $("<div/>", {class: "tier2_content"})
  PORTAL.Handlers.sort tier2Content
  layers = (createLayerView layer, i for layer, i in getLayerNames())

  tier2Content.append layer for layer in layers
  tier2Header.append(plus).append(input).append(h4).append(remove)
  tier2.append(tier2Header).append(tier2Content)
  $("#addWmsButton").parent().prepend tier2

hideModal = -> $("#addWmsModal").modal "hide"

addOLLayers = -> PORTAL.Utils.addLayer buildLayerObject(layer,i) for layer,i in getLayerNames()

sortLayers = -> PORTAL.Utils.sortLayers()

buildLayerObject = (layerName, index) ->
  {
    name: layerName,
    displayName: layerName,
    serviceUrl: $("#addWmsModalUrl").val(),
    index: "0-"+priv.wmsNumber+"-"+index,
    defaultVisible: true
  }

getLayerNames = ->
  layerNames = []
  $("#addWmsLayerNames input").each (i,e) ->
    if $(this).val().length
      layerNames.push $(this).val()
  return layerNames

createLayerView = (layerName, layerNumber) ->
  tier3 = $("<div/>", {class: "tier3"})
  tier3Content = $("<div/>", {class: "tier3_content"})
  input = $("<input/>", {id: "toggler-0-"+priv.wmsNumber+"-"+layerNumber, type: "checkbox", class: "layer-toggler", change: -> PORTAL.Handlers.layerToggled $(this)})
  label = $("<label/>", {for: "toggler-0-"+priv.wmsNumber+"-"+layerNumber, text: layerName})
  tier3.append tier3Content.append(input).append(label)

cleanUpModal = ->
  $("#addWmsModal i.icon-remove").parent().remove()
  $("#addWmsModal input").val ""
