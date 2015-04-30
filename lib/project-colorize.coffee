GeoPattern = require 'geopattern'

module.exports =
  activate: (state) ->
    pattern = GeoPattern.generate atom.project.getPaths().sort().join(':')

    style = document.createElement 'style'
    style.type = 'text/css'
    style.innerText =  '.tab-bar { background-image: ' + pattern.toDataUrl() + ';}'

    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.appendChild style
