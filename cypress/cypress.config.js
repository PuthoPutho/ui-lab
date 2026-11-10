const { defineConfig } = require('cypress')

module.exports = defineConfig({
  // the same page size as in Parts 2 and 3
  viewportWidth: 1280,
  viewportHeight: 1600,
  // retry each query and check for up to 10 seconds
  defaultCommandTimeout: 10000,
  // record a video of each spec during npx cypress run
  video: true,
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
})
