window.prepareMap = ->
  do createProjections
  do createEventListeners
  do createMap
  do createLayersSwitcher
  do createControllers
  do finish


createProjections = ->
  Proj4js.defs["EPSG:2177"] = '+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs';
  Proj4js.defs['EPSG:2180'] = '+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs';
  window.epsg2177 = new OpenLayers.Projection('EPSG:2177');
  window.epsg2180 = new OpenLayers.Projection('EPSG:2180');
  window.epsg4326 = new OpenLayers.Projection('EPSG:4326');



createEventListeners = ->
  window.zoomIn = new OpenLayers.Control.ZoomBox {active: false}
  window.zoomOut = new OpenLayers.Control.ZoomBox {active: false, out: true}
  window.mapEventListeners = {
    zoomend: (event) ->
      zoomIn.deactivate()
      zoomOut.deactivate()
      $("#open_layers_button_zoom_in, #open_layers_button_zoom_out").removeClass "active"
  }



createMap = ->
  window.map = new OpenLayers.Map "open_layers_map", {
    controls: [],
    eventListeners: window.mapEventListeners
    allOverlays: true,
    units: "m",
    projection: window.epsg2180,
    displayProjection: window.epsg4326,
    maxExtent: new OpenLayers.Bounds(
      window.configurationSettings.mapBoundingLeft,
      window.configurationSettings.mapBoundingBottom,
      window.configurationSettings.mapBoundingRight,
      window.configurationSettings.mapBoundingTop
    ),
    minScale: window.configurationSettings.mapMinScale,
    maxScale: window.configurationSettings.mapMaxScale,
    numZoomLevels: window.configurationSettings.mapNumZoomLevels
  }



createLayersSwitcher = ->
  do disableTextSelection
  do activateTreeComponent
  do activateLayersSelection
  do activateLayersSort
  addLayer layer for layer in window.layers



disableTextSelection = ->
  $("#app_layers .well").disableSelection();



activateTreeComponent = ->
  $("#app_layers h3, #app_layers h4, #app_layers i").click ->
    $(this).parent().siblings().toggle()
    $(this).parent().children("i").toggleClass("icon-plus").toggleClass("icon-minus")



activateLayersSelection = ->

  areAllChecked = (tierContent, togglers, haveToBeChecked) ->
    result = true
    $(tierContent).find(togglers).each (i, e) ->
      if $(e).is(":checked")!=haveToBeChecked
        result = false
    result

  setChecked = (element, tier, togglers, haveToBeChecked, triggerChangeEvent) ->
    $(element).parents(tier).find(togglers).each (i, toggler) ->
      $(toggler).attr "checked", haveToBeChecked
      if triggerChangeEvent
        $(toggler).change()

  areAllWmsActivated = (tier1Content) -> areAllChecked tier1Content, ".wms-toggler", true
  areAllWmsDeactivated = (tier1Content) -> areAllChecked tier1Content, ".wms-toggler", false
  areAllLayersActivated = (tier2Content) -> areAllChecked tier2Content, ".layer-toggler", true
  areAllLayersDeactivated = (tier2Content) -> areAllChecked tier2Content, ".layer-toggler", false


  $("#app_layers .layer-toggler").change ->
    layer = findLayer buildIdWithPrefix $(this).attr("id"), "layer"
    if layer==null
      return
    layer.setVisibility $(this).is(":checked")
    if areAllLayersActivated $(this).parents(".tier2_content")
      setChecked $(this), ".tier2", ".wms-toggler", true, false
    if areAllLayersDeactivated $(this).parents(".tier2_content")
      setChecked $(this), ".tier2", ".wms-toggler", false, false


  $("#app_layers .wms-toggler").change ->
    if $(this).is(":checked")
      setChecked $(this), ".tier2", ".layer-toggler", true, true
    else if areAllLayersActivated $(this).parents(".tier2").children(".tier2_content")
      setChecked $(this), ".tier2", ".layer-toggler", false, true
    if areAllWmsActivated $(this).parents(".tier1_content")
      setChecked $(this), ".tier1", ".source-toggler", true, false
    if areAllWmsDeactivated $(this).parents(".tier1_content")
      setChecked $(this), ".tier1", ".source-toggler", false, false


  $("#app_layers .source-toggler").change ->
    if $(this).is(":checked")
      setChecked $(this), ".tier1", ".wms-toggler", true, true
    else if areAllWmsActivated $(this).parents(".tier1").children(".tier1_content")
      setChecked $(this), ".tier1", ".wms-toggler", false, true



activateLayersSort = ->
  $("#app_layers, .tier1_content, .tier2_content").sortable {cursor: "move", stop: (event, ui) -> sortLayers()}



addLayer = (layer) ->
  olLayer = new OpenLayers.Layer.WMS(layer.displayName, layer.serviceUrl,
    {layers: layer.name, transparent: true},
    {visibility: false, singleTile: true, ratio: 1.0, buffer: 1, transitionEffect: "resize"}
  )
  olLayer.id = "layer-" + layer.index;
  window.map.addLayer olLayer
  if layer.defaultVisible==true
    $("#" + buildIdWithPrefix olLayer.id, "toggler").click()



sortLayers = ->
  $("#app_layers .tier3 input").each (i, e) ->
    window.map.setLayerIndex findLayer(buildIdWithPrefix($(this).attr("id"), "layer"), i)



findLayer = (id) ->
  layers = (layer for layer in window.map.layers when layer.id==id)
  if layers.empty
    return null
  else
    return layers[0]



buildIdWithPrefix = (id, prefix) ->
  parts = id.split "-"
  parts[0] = prefix
  parts.join "-"



finish = ->
  window.map.setCenter(
    new OpenLayers.LonLat(configurationSettings.mapInitialX, configurationSettings.mapInitialY),
    configurationSettings.mapInitialZ
  )
  do sortLayers
