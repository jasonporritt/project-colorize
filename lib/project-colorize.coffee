GeoPattern = require 'geopattern'

module.exports =
  activate: (state) ->
    pattern = GeoPattern.generate atom.project.getPath()
    atom.workspaceView.append '<style type="text/css"> .tab-bar { background-image: ' + pattern.toDataUrl() + ';} </style>'
