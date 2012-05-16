window.setTopLevelLayout = ->
  lite =
    resizable: false
    slidable: false
    closable: false
    spacing_open: false
  layersSwitcherOptions =
    slidable: false
    resizerTip: "zmień rozmiar"
    togglerTip_open: "zamknij"
    togglerTip_closed: "otwórz"
    minSize: 200
    size: 450
    maxSize: 600
    spacing_open: 5
    spacing_closed: 5
  $("body").layout {defaults: lite}
  $("#app_page").layout {north: lite, west: layersSwitcherOptions}