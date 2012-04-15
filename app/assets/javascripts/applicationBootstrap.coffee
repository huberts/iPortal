$ ->
  do setTopLevelLayout
  do initializeMap
  do setCollapses

setTopLevelLayout = ->
  lite = 
    resizable: false
    slidable: false
    closable: false
    spacing_open: false
  $("body").layout {defaults: lite}
  $("#app_page").layout {north: lite}

initializeMap = ->
  Proj4js.defs['EPSG:2180'] = '+proj=tmerc +lat_0=0 +lon_0=19 +k=0.9993 +x_0=500000 +y_0=-5300000 +ellps=GRS80 +units=m +no_defs';
  Proj4js.defs["EPSG:2177"] = '+proj=tmerc +lat_0=0 +lon_0=18 +k=0.999923 +x_0=6500000 +y_0=0 +ellps=GRS80 +units=m +no_defs';
  epsg2177 = new OpenLayers.Projection('EPSG:2177');
  epsg2180 = new OpenLayers.Projection('EPSG:2180');
  epsg4326 = new OpenLayers.Projection('EPSG:4326');

  map = new OpenLayers.Map "open_layers_map", {
    allOverlays: true,
    projection: epsg2180,
    maxExtent: new OpenLayers.Bounds(329511.16, 440448.231, 336647.24, 449035.96)
  }
  addLayer layer for layer in window.layers
  hydro = new OpenLayers.Layer.WMS("Hydro", "http://sdi.geoportal.gov.pl/wms_hydro/wmservice.aspx", {layers: "HYDRO_50_92"})
  map.addLayers([hydro])
  map.zoomToMaxExtent()

addLayer = ->
  alert layer.visibleName


setCollapses = ->
  $(".collapse").each (index, element) ->
    $(element).on "show", ->
      $(element).siblings("h3").addClass "ui-corner-top"
      $(element).siblings("h3").removeClass "ui-corner-all"
    $(element).on "hidden", ->
      $(element).siblings("h3").addClass "ui-corner-all"
      $(element).siblings("h3").removeClass "ui-corner-top"


