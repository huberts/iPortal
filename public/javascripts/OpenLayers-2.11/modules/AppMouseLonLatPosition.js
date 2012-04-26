/* Copyright (c) 2006-2011 by OpenLayers Contributors (see authors.txt for
 * full list of contributors). Published under the Clear BSD license.
 * See http://svn.openlayers.org/trunk/openlayers/license.txt for the
 * full text of the license. */


/**
 * @requires OpenLayers/Control.js
 * @requires OpenLayers/Control/MousePosition.js
 */

/**
 * Class: OpenLayers.Control.AppMouseLonLatPosition
 * The MousePosition control displays geographic coordinates of the mouse
 * pointer, as it is moved about the map.
 *
 * Inherits from:
 *  - <OpenLayers.Control.MousePosition>
 */
OpenLayers.Control.AppMouseLonLatPosition = OpenLayers.Class(OpenLayers.Control.MousePosition, {

    /**
     * Constructor: OpenLayers.Control.AppMouseLonLatPosition
     *
     * Parameters:
     * elementId - {DOMElement ID}
     * options - {Object}
     */
    initialize: function(elementId, options) {
        OpenLayers.Control.prototype.initialize.apply(this, [options]);
        this.element = OpenLayers.Util.getElement(document.getElementById(elementId));
        this.emptyString = "współrzędne (1992)";
        this.prefix = "X: ";
        this.separator = " Y: ";
        this.displayProjection = window.map.projection;
        this.numDigits = 2;
    },

    /**
     * Method: formatOutput
     * Override to provide custom display output
     *
     * Parameters:
     * lonLat - {<OpenLayers.LonLat>} Location to display
     */
    formatOutput: function(lonLat) {
        var digits = parseInt(this.numDigits);
        var newHtml =
            this.prefix +
                lonLat.lat.toFixed(digits) +
                this.separator +
                lonLat.lon.toFixed(digits) +
                this.suffix;
        return newHtml;
    },

    CLASS_NAME: "OpenLayers.Control.AppMouseLonLatPosition"
});
