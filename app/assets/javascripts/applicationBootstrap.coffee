$ ->
  do setTopLevelLayout
  do window.prepareMap

setTopLevelLayout = ->
  lite = 
    resizable: false
    slidable: false
    closable: false
    spacing_open: false
  $("body").layout {defaults: lite}
  $("#app_page").layout {north: lite}


