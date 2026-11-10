# ui-lab

ITDS362 UI testing lab. Test case QP-01 (QuickPizza) automated with two tools.

Tool parts chosen: **Part 3 Robot Framework** and **Part 4 Cypress**.

## robot/
Robot Framework tests with SeleniumLibrary: `first.robot`, `web_form.robot`, and `pizza_scenario.robot` (QP-01) using keywords in `resources/quickpizza.resource`. `results/run1` and `results/run2` hold the report, log and screenshots of two full headless runs.

Needs the `CHROMEDRIVER` environment variable (see Step 0.3). Run, from `robot/` with the virtual environment active (`pip install -r requirements.txt` first):

```
robot -d results/run1 -v BROWSER:headlesschrome pizza_scenario.robot
```

## cypress/
Cypress specs `cypress/e2e/web-form.cy.js` and `cypress/e2e/pizza-scenario.cy.js` (QP-01), with the custom command `adminLogin` in `cypress/support/commands.js`. `cypress/videos` and `cypress/screenshots` hold the evidence of a full run.

Run, from `cypress/` (`npm install` first):

```
npx cypress run --browser chrome
```
