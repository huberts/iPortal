/* Copyright (c) 2006-2011 by OpenLayers Contributors (see authors.txt for
 * full list of contributors). Published under the Clear BSD license.
 * See http://svn.openlayers.org/trunk/openlayers/license.txt for the
 * full text of the license. */


/**
 * @requires OpenLayers/Control/Scale.js
 * @requires OpenLayers/Control.js
 * @requires OpenLayers/Lang.js
 */

/**
 * Class: OpenLayers.Control.AppScale
 * The AppScale control displays the current map scale as a ratio (e.g. Scale =
 * 1:1M). By default it is displayed in the lower right corner of the map.
 *
 * Inherits from:
 *  - <OpenLayers.Control.Scale>
 */
OpenLayers.Control.AppScale = OpenLayers.Class(OpenLayers.Control.Scale, {

    /**
     * Constructor: OpenLayers.Control.AppScale
     *
     * Parameters:
     * elementId - {DOMElement ID}
     * options - {Object}
     */
    initialize: function(elementId, options) {
        OpenLayers.Control.prototype.initialize.apply(this, [options]);
        this.element = OpenLayers.Util.getElement(document.getElementById(elementId));
    },

    /**
     * Method: updateScale <<OVERRIDE>>
     */
    updateScale: function() {
        var scale;
        if(this.geodesic === true) {
            var units = this.map.getUnits();
            if(!units) {
                return;
            }
            var inches = OpenLayers.INCHES_PER_UNIT;
            scale = (this.map.getGeodesicPixelSize().w || 0.000001) *
                inches["km"] * OpenLayers.DOTS_PER_INCH;
        } else {
            scale = this.map.getScale();
        }

        if (!scale) {
            return;
        }

        scale = Math.round(scale);

        this.element.innerHTML = OpenLayers.i18n("Scale = 1 : ${scaleDenom}", {'scaleDenom':scale});
    },

    CLASS_NAME: "OpenLayers.Control.AppScale"
});
