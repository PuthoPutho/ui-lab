# UI lab results

Tool parts that I chose: Part 3 (Robot Framework) and Part 4 (Cypress)

## Part 0
- Step 0.1, Chrome version: 157.0.8103.39 (Windows, x64)
- Step 0.3, ChromeDriver version: 157.0.8103.39 (same as Chrome)
- Step 0.4, locator of Pizza, Please!: `button[name=pizza-please]`
- Step 0.4, locator of Excluded tools: `select`
- Step 0.4, locator of Must be vegetarian: `#default-checkbox`
- Step 0.4, locator of Custom Pizza Name: `input#pizza-name`
- Step 0.5, pizza name, tool and calories of the run by hand: TODO (run QP-01 by hand once and fill in; see note below)

Note: the table below is filled from the first automated headless run (Robot run 1), not from a hand run. Replace it with your own hand-run observations before submitting.

| Step | Actual result | Pass or fail |
|------|---------------|--------------|
| 1 | Heading "Looking to break out of your pizza routine?" shown | Pass |
| 2 | Max Calories per Slice, Excluded tools, Must be vegetarian, Custom Pizza Name visible | Pass |
| 3 | Fields hold 600, Knife, ticked, `Lab Pizza 20261110-220418` | Pass |
| 4 | Pizza named `Lab Pizza 20261110-220418`, tool Scissors, 350 calories per slice | Pass |
| 5 | "Please log in first." | Pass |
| 6 | "Latest pizza recommendations" shown after sign in | Pass |
| 7 | List line with the pizza name and tool=Scissors | Pass |

## Part 3: Robot Framework
- robot --version: Robot Framework 7.5.1 (Python 3.10.10 on win32)
- Step 3.2, failure message for the wrong title: `Title should have been 'Web Form' but was 'Web form'.`
- Step 3.8, run 1, result, elapsed time and pizza name: PASS, 15.4 s, `Lab Pizza 20261110-220418` (tool Scissors, 350 calories)
- Step 3.8, run 2, result, elapsed time and pizza name: PASS, 16.3 s, `Lab Pizza 20261110-220442` (tool Pizza, 325 calories)

## Part 4: Cypress
- node --version, npm --version and npx cypress version: v22.19.0, 11.17.0, Cypress 16.2.1
- Step 4.3, failure message for the wrong title: `Timed out retrying after 10000ms` with `-'Web form'` (actual) and `+'Web Form'` (expected)
- Step 4.6, tool and calories in the answer of POST /api/pizza: not read from the API response directly. The spec asserts that the page shows the same tool and calories as the response. Run 2 page showed Tool: Scissors, Calories per slice: 500.
- Step 4.7, the line of the admin list that shows your pizza: `Lab Pizza 20261110-221605 (tool=Scissors, ingredients_number=6) (newest)`
- Step 4.8, run 1, result, duration and pizza name: all specs passed, 00:26 (pizza-scenario 00:18, web-form 00:07), `Lab Pizza 20261110-221448` (tool=Pizza cutter)
- Step 4.8, run 2, result, duration and pizza name: all specs passed, 00:25 (pizza-scenario 00:20, web-form 00:04), `Lab Pizza 20261110-221605` (tool=Scissors)
- Step 4.9 (optional), browser and result: not done

## Part B
1. The three number boxes share the id `floating_filled` (`$$("#floating_filled").length` gave 3), so an id finds three elements and cannot tell them apart. The tests find the box through its label text instead. If each input had a unique id, or a `name` such as `max-calories`, a test could use it directly. That helps a tester because the locator would not depend on label wording or on the DOM order next to the label.
2. This is a consistency oracle: two parts of the system (the admin list and the recommendation) must agree. It would catch a fault where the server saves a different tool or an older pizza than the one it returned, so the admin list shows tool=Knife while the recommendation said Scissors.
3. Check that no ingredient of the recommended pizza is a meat or fish item. The test would need either a list of vegetarian ingredients (a test data source) or the `vegetarian` field of the POST /api/pizza response, which Cypress already sees through `cy.intercept` (`"vegetarian": true`). Compare that field with the ticked checkbox.
4. Robot: SeleniumLibrary keywords wait with explicit `Wait Until ...` keywords and a 10 s library timeout. Cypress retries `cy.get` and `should` for up to 10 s, so I wrote no explicit waits. Robot took longer to write because of the resource file and keywords, Cypress was shorter. Robot gave a log.html with a step tree and screenshots (run about 15 s), Cypress gave an mp4 video plus the terminal table (run about 20 s). The Robot log is easier to read for failures, the Cypress video is easier to watch.
5. Cypress. First, retried commands removed all explicit waits, which kept the spec short and avoided timing mistakes. Second, `cy.intercept` let me compare the API request and response with the page, and it needed no driver setup (no ChromeDriver variable).
6. (Part 3) The calories locator lives once, in the variable `${MAX CALORIES}` in `resources/quickpizza.resource`. `pizza_scenario.robot` only calls keywords such as `Fill In The Pizza Request`, so it never sees the locator and I change one line.
7. (Part 4) Cypress clears cookies before each test. QuickPizza runs on several servers, and a cookie keeps the browser on one server. The admin list shows only the pizzas of that server. If steps 6 and 7 were a second test, the browser could land on another server, and the list would not contain the pizza from steps 1 to 5, so step 7 would fail.
