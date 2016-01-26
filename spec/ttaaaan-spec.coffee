Ttaaaan = require '../lib/ttaaaan'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Ttaaaan", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('ttaaaan')

  describe "when the ttaaaan:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.ttaaaan')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'ttaaaan:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.ttaaaan')).toExist()

        ttaaaanElement = workspaceElement.querySelector('.ttaaaan')
        expect(ttaaaanElement).toExist()

        ttaaaanPanel = atom.workspace.panelForItem(ttaaaanElement)
        expect(ttaaaanPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'ttaaaan:toggle'
        expect(ttaaaanPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.ttaaaan')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'ttaaaan:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        ttaaaanElement = workspaceElement.querySelector('.ttaaaan')
        expect(ttaaaanElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'ttaaaan:toggle'
        expect(ttaaaanElement).not.toBeVisible()
