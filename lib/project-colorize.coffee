GeoPattern = require 'geopattern'

module.exports =
  config:
    defaultPatternString:
      type: 'string'
      default: ''
      description: 'Used to generate the pattern when no project folder is open'
      order: 1
    noPatternOnEmptyString:
      type: 'boolean'
      default: true
      order: 2

  configPath: 'project-colorize.defaultPatternString'

  activate: (state) ->
    # Default to using the project path(s) to generate the pattern
    projectPaths = atom.project.getPaths().sort().join(':')

    # Get config path for this set of project paths
    @configPath = 'project-colorize.' + projectPaths if projectPaths

    # Get custom pattern string
    patternString = atom.config.get @configPath

    if not patternString?
      # No custom pattern string was found, save project paths as pattern string
      atom.config.set @configPath, projectPaths

    # Observe config changes
    atom.config.observe @configPath, => @setPattern()
    atom.config.observe 'project-colorize.noPatternOnEmptyString', => @setPattern()

  setPattern: () ->
    # Generate the pattern
    patternString = atom.config.get @configPath
    pattern = GeoPattern.generate patternString

    # TODO: Remove any earlier <style> element created by this package?
    style = document.createElement 'style'
    style.type = 'text/css'

    if not patternString and atom.config.get 'project-colorize.noPatternOnEmptyString'
      style.innerText = '.tab-bar { background-image: none;}'
    else
      style.innerText = '.tab-bar { background-image: ' + pattern.toDataUrl() + ';}'

    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.appendChild style

