PORTAL.activateOwnLayers = ->

  $("#addWmsModal .modal-body button").click ->
    $("#addWmsLayerNames").append modalLayerView
    $("#addWmsModal i.icon-remove").click -> $(this).parent().remove()


  $("#addWmsModal .modal-footer a").click ->

    if canAddWms()
      wms = addWmsView()
      addOLLayers()
      updateControlElements(wms)
#      sortLayers()
      cleanUpModal()
      closeModal()


# labels and icons in added elements don't work
# add to olLayers
# sort layers


canAddWms = -> $("#addWmsModalVisibleName").val().length && $("#addWmsModalUrl").val().length && getLayerNames().length


addWmsView = ->
  wmsNumber = $("#addWmsButton").siblings().length
  wmsVisibleName = $("#addWmsModalVisibleName").val()
  layersView = (layerView layer,i for layer,i in getLayerNames()).join ""
  html = """
      <div class="tier2">
        <div class="tier2_header">
          <i class="icon-plus icon-white"></i>
          <input id="toggler-0-#{wmsNumber}" type="checkbox" class="wms-toggler" />
          <h4>#{wmsVisibleName}</h4>
          <i class="icon-remove icon-white"></i>
          </div>
        <div class="tier2_content">#{layersView}</div>
      </div>
      """
  $("#addWmsButton").parent().prepend html


addOLLayers = ->
  PORTAL.addLayer buildLayerObject(layer,i) for layer,i in getLayerNames()


updateControlElements = (wmsElement) ->
  wmsElement.find("h4, i").not(".icon-remove").click -> PORTAL.handleTreeClick $(this)

buildLayerObject = (layerName, index) ->
  {
    name: layerName,
    displayName: layerName,
    serviceUrl: $("#addWmsModalUrl").val(),
    index: "0-" + ($("#addWmsButton").siblings().length-1) + "-" + index,
    defaultVisible: true
  }


cleanUpModal = ->
  $("#addWmsModal i.icon-remove").parent().remove()
  $("#addWmsModal input").val("")


closeModal = ->
  $("#addWmsModal").modal "hide"


getLayerNames = ->
  layerNames = []
  $("#addWmsLayerNames input").each (i,e) ->
    if $(this).val().length
      layerNames.push $(this).val()
  return layerNames


modalLayerView = """
<div><input class="own-layer-name" type="text" placeholder="Nazwa warstwy" /><i class="icon-remove icon-white"></i></div>
"""

layerView = (name, index) ->
  wmsNumber = $("#addWmsButton").siblings().length
  """
  <div class="tier3"><div class="tier3_content">
  <input id="toggler-0-#{wmsNumber}-#{index}" type="checkbox" class="layer-toggler" />
  <label for="toggler-0-#{wmsNumber}-#{index}">#{name}</label>
  </div></div>
  """
