const { defineConfig } = require('cypress')

module.exports = defineConfig({
  // setupNodeEvents can be defined in either
  // the e2e or component configuration
  e2e: {
    baseUrl: "http://localhost:3000",
    viewportHeight: 1280,
    viewportWidth: 1200,
  },
  screenshotsFolder: "tmp/cypress_screenshots",
  videosFolder: "tmp/cypress_videos",
  trashAssetsBeforeRuns: false
})
