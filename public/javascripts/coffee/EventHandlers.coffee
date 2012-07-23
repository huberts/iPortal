PORTAL.Handlers = {}


PORTAL.Handlers.treeClick = (element) ->
  element.parent().siblings().toggle("fast")
  element.parent().children("i.icon-plus, i.icon-minus").toggleClass("icon-plus").toggleClass("icon-minus")


PORTAL.Handlers.checkLayerToAdd = (addWmsLayerButton) ->
  addWmsLayerButton.children("i").toggleClass("icon-remove").toggleClass("icon-ok")


PORTAL.Handlers.sort = (element) ->
  element.sortable { update: PORTAL.Utils.sortLayers  }




PORTAL.Handlers.layerToggled = (layerCheckbox) ->

  layerCheckboxesOnMyLevel = layerCheckbox.parents(".tier2_content")
  myWmsCheckbox =            layerCheckbox.parents(".tier2").find(".wms-toggler")

  if priv.areAllLayersActivated layerCheckboxesOnMyLevel
    priv.setCheckboxState myWmsCheckbox, priv.STATE_ON
  else if priv.areAllLayersDeactivated layerCheckboxesOnMyLevel
    priv.setCheckboxState myWmsCheckbox, priv.STATE_OFF
  else
    priv.setCheckboxState myWmsCheckbox, priv.STATE_MIDDLE

  priv.setOpenLayersLayerVisibility layerCheckbox




PORTAL.Handlers.wmsToggled = (wmsCheckbox) ->

  myChildrenLayerCheckboxesBag = wmsCheckbox.parents(".tier2").children(".tier2_content")
  myChildrenLayerCheckboxes =    wmsCheckbox.parents(".tier2").find(".layer-toggler")
  wmsCheckboxesOnMyLevel =       wmsCheckbox.parents(".tier1_content")
  mySourceCheckbox =             wmsCheckbox.parents(".tier1").find(".source-toggler")
  wmsCount =                     wmsCheckboxesOnMyLevel.children(".tier2")

  if priv.getCheckboxState(wmsCheckbox)==priv.STATE_ON
    priv.setCheckboxState myChildrenLayerCheckboxes, priv.STATE_ON
  else if priv.getCheckboxState(wmsCheckbox)==priv.STATE_OFF && priv.areAllLayersActivated myChildrenLayerCheckboxesBag
      priv.setCheckboxState myChildrenLayerCheckboxes, priv.STATE_OFF

  if wmsCount == 0 || priv.areAllWmsDeactivated wmsCheckboxesOnMyLevel
    priv.setCheckboxState mySourceCheckbox, priv.STATE_OFF
  else if priv.areAllWmsActivated wmsCheckboxesOnMyLevel
    priv.setCheckboxState mySourceCheckbox, priv.STATE_ON
  else
    priv.setCheckboxState mySourceCheckbox, priv.STATE_MIDDLE




PORTAL.Handlers.sourceToggled = (sourceCheckbox) ->

  myChildrenWmsCheckboxesBag = sourceCheckbox.parents(".tier1").children(".tier1_content")
  myChildrenWmsCheckboxes =    sourceCheckbox.parents(".tier1").find(".wms-toggler")

  if priv.getCheckboxState(sourceCheckbox)==priv.STATE_ON
    priv.setCheckboxState myChildrenWmsCheckboxes, priv.STATE_ON
  else if priv.getCheckboxState(sourceCheckbox)==priv.STATE_OFF && priv.areAllWmsActivated myChildrenWmsCheckboxesBag
    priv.setCheckboxState myChildrenWmsCheckboxes, priv.STATE_OFF



PORTAL.Handlers.removeSource = (source) ->
  source.parents(".tier1").find(".wms-toggler").each (i, wms) ->
    PORTAL.Handlers.removeWms $(wms)
  tier = source.closest ".tier1"
  tier.hide "fast", -> $(this).remove()


PORTAL.Handlers.removeWms = (wms) ->
  wms.attr "disabled", true
  wms.parents(".tier2").children(".tier2_content").find("input").each (i, layer) ->
    PORTAL.Handlers.removeLayer $(layer)
  tier = wms.parents ".tier2"
  tier.hide "fast", ->
    wmsCheckboxesOnMyLevel =  $(this).parents(".tier1_content")
    sourceCheckbox         =  $(this).parents(".tier1").find(".source-toggler")
    $(this).remove()

    wmsCount = wmsCheckboxesOnMyLevel.children(".tier2")
    if wmsCount == 0 || priv.areAllWmsDeactivated wmsCheckboxesOnMyLevel
      priv.setCheckboxState sourceCheckbox, priv.STATE_OFF
    else if priv.areAllWmsActivated wmsCheckboxesOnMyLevel
      priv.setCheckboxState sourceCheckbox, priv.STATE_ON
    else
      priv.setCheckboxState sourceCheckbox, priv.STATE_MIDDLE


PORTAL.Handlers.removeLayer = (layer) ->
  layer.parents(".tier3").children(".tier3_content").find("input").each (i, elem) ->
    PORTAL.Utils.removeLayer PORTAL.Utils.buildIdWithPrefix $(elem).attr("id"), "layer"
  tier = layer.closest ".tier3"
  tier.hide "fast", ->
    layerCheckboxesOnMyLevel = $(this).parents(".tier2_content")
    wmsCheckbox              = $(this).parents(".tier2").find(".wms-toggler")
    $(this).remove()

    hasLayers = layerCheckboxesOnMyLevel.find(".layer-toggler").length > 0
    if hasLayers
      if priv.areAllLayersActivated layerCheckboxesOnMyLevel
        priv.setCheckboxState wmsCheckbox, priv.STATE_ON
      else if priv.areAllLayersDeactivated layerCheckboxesOnMyLevel
        priv.setCheckboxState wmsCheckbox, priv.STATE_OFF
      else
        priv.setCheckboxState wmsCheckbox, priv.STATE_MIDDLE
    else
      wmsRemove = wmsCheckbox.parent().find("i.service-remove")
      wmsRemove.click() if !wmsRemove.attr "disabled"


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
