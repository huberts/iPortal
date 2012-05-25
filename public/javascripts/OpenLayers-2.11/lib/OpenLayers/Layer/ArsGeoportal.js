/* Copyright (c) 2006-2011 by OpenLayers Contributors (see authors.txt for
 * full list of contributors). Published under the Clear BSD license.
 * See http://svn.openlayers.org/trunk/openlayers/license.txt for the
 * full text of the license. */

/**
 * @requires OpenLayers/Layer/Grid.js
 * @requires OpenLayers/Tile/Image.js
 */

/**
 * Class: OpenLayers.Layer.ArsGeoportal
 * The ArsGeoportal class is designed to make it easier for people who have tiles
 * arranged by a standard XYZ grid, designed specially for ARS Geoportal services.
 *
 * Inherits from:
 *  - <OpenLayers.Layer.XYZ>
 */
OpenLayers.Layer.ArsGeoportal = OpenLayers.Class(OpenLayers.Layer.XYZ, {

    /**
     * Constructor: OpenLayers.Layer.ArsGeoportal
     *
     * Parameters:
     * name - {String}
     * url - {String}
     * options - {Object} Hashtable of extra options to tag onto the layer
     */
    initialize: function(name, url, options) {
        url = url || this.url;
        name = name || this.name;
        var newArguments = [name, url, options];
        OpenLayers.Layer.XYZ.prototype.initialize.apply(this, newArguments);
    },

    /**
     * APIMethod: clone
     * Create a clone of this layer
     *
     * Parameters:
     * obj - {Object} Is this ever used?
     *
     * Returns:
     * {<OpenLayers.Layer.XYZ>} An exact clone of this OpenLayers.Layer.XYZ
     */
    clone: function (obj) {

        if (obj == null) {
            obj = new OpenLayers.Layer.ArsGeoportal(this.name,
                this.url,
                this.getOptions());
        }

        //get all additions from superclasses
        obj = OpenLayers.Layer.XYZ.prototype.clone.apply(this, [obj]);

        return obj;
    },

    /**
     * Method: getXYZ
     * Calculates x, y and z for the given bounds. Note there is only one difference between this and XYZ: in y value calculation.
     *
     * Parameters:
     * bounds - {<OpenLayers.Bounds>}
     *
     * Returns:
     * {Object} - an object with x, y and z properties.
     */
    getXYZ: function(bounds) {
        var res = this.map.getResolution();
        var x = Math.round((bounds.left - this.maxExtent.left) /
            (res * this.tileSize.w));
        var y = Math.round((bounds.top - this.maxExtent.bottom) /
            (res * this.tileSize.h)) - 1;
        var z = this.serverResolutions != null ?
            OpenLayers.Util.indexOf(this.serverResolutions, res) :
            this.map.getZoom() + this.zoomOffset;

        var limit = Math.pow(2, z);
        if (this.wrapDateLine)
        {
            x = ((x % limit) + limit) % limit;
        }

        return {'x': x, 'y': y, 'z': z};
    },

    CLASS_NAME: "OpenLayers.Layer.ArsGeoportal"
});
