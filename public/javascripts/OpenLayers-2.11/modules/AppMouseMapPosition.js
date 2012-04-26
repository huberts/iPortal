/* Copyright (c) 2006-2011 by OpenLayers Contributors (see authors.txt for
 * full list of contributors). Published under the Clear BSD license.
 * See http://svn.openlayers.org/trunk/openlayers/license.txt for the
 * full text of the license. */


/**
 * @requires OpenLayers/Control.js
 * @requires OpenLayers/Control/MousePosition.js
 */

/**
 * Class: OpenLayers.Control.MousePosition
 * The MousePosition control displays geographic coordinates of the mouse
 * pointer, as it is moved about the map.
 *
 * Inherits from:
 *  - <OpenLayers.Control>
 */
OpenLayers.Control.AppMouseMapPosition = OpenLayers.Class(OpenLayers.Control.MousePosition, {

    initialize: function(elementId, options) {
        OpenLayers.Control.prototype.initialize.apply(this, [options]);
        this.element = OpenLayers.Util.getElement(document.getElementById(elementId));
        this.emptyString = "współrzędne (szer./dł.)";
    },

    /**
     * Method: formatOutput
     * Override to provide custom display output
     *
     * Parameters:
     * lonLat - {<OpenLayers.LonLat>} Location to display
     */
    formatOutput: function(lonLat) {
        return OpenLayers.AppUtils.getFormattedLonLat(lonLat.lat, 'lat') + " " +
            OpenLayers.AppUtils.getFormattedLonLat(lonLat.lon, 'lon');
    },

    CLASS_NAME: "OpenLayers.Control.AppMouseMapPosition"
});
