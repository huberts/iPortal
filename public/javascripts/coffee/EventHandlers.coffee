PORTAL.Handlers = {}


PORTAL.Handlers.treeClick = (element) ->
  element.parent().siblings().toggle()
  element.parent().children("i.icon-plus, i.icon-minus").toggleClass("icon-plus").toggleClass("icon-minus")


PORTAL.Handlers.layerDetails = (element) ->
  element.siblings(".layer-details").toggle()


PORTAL.Handlers.changeLayerOpacity = (element) ->
  togglerId = element.parents(".tier3_content").children("input.layer-toggler").first().attr "id"
  layerId = PORTAL.Utils.buildIdWithPrefix togglerId, "layer"
  layer = PORTAL.Utils.findLayer layerId
  if layer==null
    return
  increment = 0
  if (element.hasClass "icon-minus-sign") && (layer.opacityPercentage>0)
    increment = -25
  if (element.hasClass "icon-plus-sign") && (layer.opacityPercentage<100)
    increment = 25
  layer.opacityPercentage += increment
  layer.setOpacity layer.opacityPercentage/100
  element.siblings("span").text "" + layer.opacityPercentage + "%"


PORTAL.Handlers.sort = (element) ->
  element.sortable { stop: PORTAL.Utils.sortLayers  }




PORTAL.Handlers.layerToggled = (layerCheckbox) ->

  priv.setOpenLayersLayerVisibility layerCheckbox

  layerCheckboxesOnMyLevel = layerCheckbox.parents(".tier2_content")
  myWmsCheckbox =            layerCheckbox.parents(".tier2").find(".wms-toggler")

  if priv.areAllLayersActivated layerCheckboxesOnMyLevel
    priv.setCheckboxState myWmsCheckbox, priv.STATE_ON
  else if priv.areAllLayersDeactivated layerCheckboxesOnMyLevel
    priv.setCheckboxState myWmsCheckbox, priv.STATE_OFF
  else
    priv.setCheckboxState myWmsCheckbox, priv.STATE_MIDDLE




PORTAL.Handlers.wmsToggled = (wmsCheckbox) ->

  myChildrenLayerCheckboxesBag = wmsCheckbox.parents(".tier2").children(".tier2_content")
  myChildrenLayerCheckboxes =    wmsCheckbox.parents(".tier2").find(".layer-toggler")
  wmsCheckboxesOnMyLevel =       wmsCheckbox.parents(".tier1_content")
  mySourceCheckbox =             wmsCheckbox.parents(".tier1").find(".source-toggler")

  if priv.getCheckboxState(wmsCheckbox)==priv.STATE_ON
    priv.setCheckboxState myChildrenLayerCheckboxes, priv.STATE_ON
  else if priv.getCheckboxState(wmsCheckbox)==priv.STATE_OFF && priv.areAllLayersActivated myChildrenLayerCheckboxesBag
      priv.setCheckboxState myChildrenLayerCheckboxes, priv.STATE_OFF

  if priv.areAllWmsActivated wmsCheckboxesOnMyLevel
    priv.setCheckboxState mySourceCheckbox, priv.STATE_ON
  else if priv.areAllWmsDeactivated wmsCheckboxesOnMyLevel
    priv.setCheckboxState mySourceCheckbox, priv.STATE_OFF
  else
    priv.setCheckboxState mySourceCheckbox, priv.STATE_MIDDLE




PORTAL.Handlers.sourceToggled = (sourceCheckbox) ->

  myChildrenWmsCheckboxesBag = sourceCheckbox.parents(".tier1").children(".tier1_content")
  myChildrenWmsCheckboxes =    sourceCheckbox.parents(".tier1").find(".wms-toggler")

  if priv.getCheckboxState(sourceCheckbox)==priv.STATE_ON
    priv.setCheckboxState myChildrenWmsCheckboxes, priv.STATE_ON
  else if priv.getCheckboxState(sourceCheckbox)==priv.STATE_OFF && priv.areAllWmsActivated myChildrenWmsCheckboxesBag
    priv.setCheckboxState myChildrenWmsCheckboxes, priv.STATE_OFF




PORTAL.Handlers.removeWms = (removeIcon) ->
  source = removeIcon.parents(".tier1").find(".source-toggler")
  olIndicies = []
  removeIcon.parents(".tier2").children(".tier2_content").find("input").each (i, layer) ->
    olIndicies.push PORTAL.Utils.buildIdWithPrefix( layer.id, "layer" )
  PORTAL.Utils.removeLayer index for index in olIndicies
  removeIcon.parents(".tier2").remove()
  if priv.areAllWmsDeactivated source.parents(".tier1").children(".tier1_content")
    source.attr "checked", false




priv = {}
priv.STATE_OFF = 0
priv.STATE_MIDDLE = 0.5
priv.STATE_ON = 1


priv.setOpenLayersLayerVisibility = (layerCheckbox) ->
  layer = PORTAL.Utils.findLayer PORTAL.Utils.buildIdWithPrefix layerCheckbox.attr("id"), "layer"
  if layer!=null
    layer.setVisibility layerCheckbox.is(":checked")


priv.setCheckboxState = (checkbox, state) ->
  checkbox.each (i,e) ->
    oldState = priv.getCheckboxState $(e)
    if state==priv.STATE_ON
      $(e).removeClass "state-middle"
      $(e).attr "checked", true
    if state==priv.STATE_MIDDLE
      $(e).addClass "state-middle"
      $(e).attr "checked", false
    if state==priv.STATE_OFF
      $(e).removeClass "state-middle"
      $(e).attr "checked", false
    if oldState!=priv.getCheckboxState $(e)
      $(e).change()

priv.getCheckboxState = (checkbox) ->
  if $(checkbox).is ":checked"
    return priv.STATE_ON
  if $(checkbox).hasClass "state-middle"
    return priv.STATE_MIDDLE
  return priv.STATE_OFF


priv.areAllWmsActivated = (tier1Content) -> priv.areAllInTheSameState tier1Content, ".wms-toggler", priv.STATE_ON
priv.areAllWmsDeactivated = (tier1Content) -> priv.areAllInTheSameState tier1Content, ".wms-toggler", priv.STATE_OFF
priv.areAllLayersActivated = (tier2Content) -> priv.areAllInTheSameState tier2Content, ".layer-toggler", priv.STATE_ON
priv.areAllLayersDeactivated = (tier2Content) -> priv.areAllInTheSameState tier2Content, ".layer-toggler", priv.STATE_OFF

priv.areAllInTheSameState = (tierContent, togglers, state) ->
  result = true
  $(tierContent).find(togglers).each (i,e) ->
    if priv.getCheckboxState(e)!=state
      result = false
  result
