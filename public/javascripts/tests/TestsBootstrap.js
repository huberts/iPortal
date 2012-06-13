PORTAL = {};

PORTAL.configurationSettings = {
  mapBoundingLeft: 130000,
  mapBoundingBottom: 120000,
  mapBoundingRight: 980000,
  mapBoundingTop: 780000,
  mapResolutions: [1600,800,400,200,100,50,25,12.5,6.25,3.125,1.5625,0.78125],
  mapInitialX: 245000,
  mapInitialY: 620000,
  mapInitialZ: 4,
  urlSlashReplacement: "-.."
};

PORTAL.messages = {
  zoomToExtent: "pokaż całość",
  zoomIn: "przybliż",
  zoomOut: "oddal",
  saveUrl: "zapisz odnośnik",
  goToLocation: "przejdź do położenia",
}

PORTAL.layers = [
  {
    index: "1-1-1",
    sourceName: "Systherm-Info",
    sourceDisplayName: "Systherm-Info",
    serviceName: "Bierun",
    serviceDisplayName: "Bieruń",
    serviceUrl: "http://212.244.173.51/cgi-bin/bierun",
    serviceType: "WMS",
    name: "GMINY",
    displayName: "Gminy",
    defaultVisible: false,
    additionalOptions: ""
  }
];

PORTAL.locations = [];


function alert() {}
