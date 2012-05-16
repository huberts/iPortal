window.prepareMap = ->
  do createProjections
  do createMap
  do createLayersSwitcher
  do createControllers
  do tests
  do finish


createProjections = ->
  Proj4js.defs["EPSG:2177"] = '+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs';
  Proj4js.defs['EPSG:2180'] = '+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs';
  window.epsg2177 = new OpenLayers.Projection('EPSG:2177');
  window.epsg2180 = new OpenLayers.Projection('EPSG:2180');
  window.epsg4326 = new OpenLayers.Projection('EPSG:4326');



createMap = ->
  window.map = new OpenLayers.Map "open_layers_map", {
    controls: [],
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

  areAllLayersDeactivated = (tier2Content) ->
    allDeactivated = true
    $(tier2Content).find(".layer-toggler").each (i, e) ->
      if $(e).is(":checked")==true
        allDeactivated = false
    allDeactivated

  areAllLayersActivated = (tier2Content) ->
    allActivated = true
    $(tier2Content).find(".layer-toggler").each (i, e) ->
      if $(e).is(":checked")==false
        allActivated = false
    allActivated

  areAllWmsDeactivated = (tier1Content) ->
    allDeactivated = true
    $(tier1Content).find(".wms-toggler").each (i, e) ->
      if $(e).is(":checked")==true
        allDeactivated = false
    allDeactivated

  areAllWmsActivated = (tier1Content) ->
    allActivated = true
    $(tier1Content).find(".wms-toggler").each (i, e) ->
      if $(e).is(":checked")==false
        allActivated = false
    allActivated


  $("#app_layers .layer-toggler").change ->
    layer = findLayer buildIdWithPrefix $(this).attr("id"), "layer"
    if layer==null
      return
    layer.setVisibility $(this).is(":checked")
    if areAllLayersDeactivated $(this).parents(".tier2_content")
      $(this).parents(".tier2").find(".wms-toggler").attr "checked", false


  $("#app_layers .wms-toggler").change ->
    if $(this).is(":checked")
      $(this).parents(".tier2").find(".layer-toggler").each (index, layerToggler) ->
        $(layerToggler).attr "checked", true
        $(layerToggler).change()
    else if areAllLayersActivated $(this).parents(".tier2").children(".tier2_content")
      $(this).parents(".tier2").find(".layer-toggler").each (index, layerToggler) ->
        $(layerToggler).attr "checked", false
        $(layerToggler).change()
    if areAllWmsDeactivated $(this).parents(".tier1_content")
      $(this).parents(".tier1").find(".source-toggler").attr "checked", false


  $("#app_layers .source-toggler").change ->
    if $(this).is(":checked")
      $(this).parents(".tier1").find(".wms-toggler").each (index, wmsToggler) ->
        $(wmsToggler).attr "checked", true
        $(wmsToggler).change()
    else if areAllWmsActivated $(this).parents(".tier1").children(".tier1_content")
      $(this).parents(".tier1").find(".wms-toggler").each (index, wmsToggler) ->
        $(wmsToggler).attr "checked", false
        $(wmsToggler).change()



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


tests = ->
#  $(".level1 h3, .level1 i").click ->
#    $(this).parent().siblings(".level1_content").toggle()
#    $(this).parent().children("i").toggleClass("icon-plus").toggleClass("icon-minus")