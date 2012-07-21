
PORTAL.tooltips = ->
  $(".layer-remove, .source-remove, .service-remove, .location-remove").tooltip {
    title: PORTAL.messages.remove,
    placement: "bottom"
  }
  $(".layer-edit, .source-edit, .service-edit, .location-edit").tooltip {
    title: PORTAL.messages.edit,
    placement: "bottom"
  }
  $(".layer-default").tooltip {
    title: PORTAL.messages.layerDefaultVisible,
    placement: "bottom"
  }
  $(".service-setlocation, .initial-setlocation, .location-set").tooltip {
    title: PORTAL.messages.setLocation,
    placement: "bottom"
  }
  $(".service-setarms").tooltip {
    title: PORTAL.messages.setArms,
    placement: "bottom"
  }
  $(".service-showlocation, .initial-showlocation").tooltip {
    title: PORTAL.messages.view,
    placement: "bottom"
  }