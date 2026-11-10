# UI lab results

Tool parts that I chose: Part 3 (Robot Framework) and Part 4 (Cypress)

## Part 0
- Step 0.1, Chrome version: 157.0.8103.39 (Windows, x64)
- Step 0.3, ChromeDriver version: 157.0.8103.39 (same as Chrome)
- Step 0.4, locator of Pizza, Please!: `button[name=pizza-please]`
- Step 0.4, locator of Excluded tools: `select`
- Step 0.4, locator of Must be vegetarian: `#default-checkbox`
- Step 0.4, locator of Custom Pizza Name: `input#pizza-name`
- Step 0.5, pizza name, tool and calories of the run by hand: `Lab Pizza 20261110-HHMMSS` (I typed the placeholder text instead of the real time), tool Scissors, 475 calories per slice

| Step | Actual result | Pass or fail |
|------|---------------|--------------|
| 1 | Heading "Looking to break out of your pizza routine?" shown | Pass |
| 2 | After turning on Advanced, Max Calories per Slice, Excluded tools, Must be vegetarian and Custom Pizza Name appeared | Pass |
| 3 | Max Calories 600, Knife selected, vegetarian ticked, name `Lab Pizza 20261110-HHMMSS` | Pass |
| 4 | Answer named `Lab Pizza 20261110-HHMMSS`, tool Scissors (not Knife), 475 calories per slice (600 or fewer), no meat ingredients | Pass |
| 5 | "Please log in first." shown below the buttons | Pass |
| 6 | Signed in with admin/admin, "Latest pizza recommendations" shown | Pass |
| 7 | The pizza name was not in the list of 15 pizzas, after opening /admin and pressing Refresh three times. Other users' pizzas filled the list. | Fail |

Step 7 failed in my hand run. I think the list only shows the 15 latest pizzas of a server and many users add pizzas at the same time, so my pizza may have moved out of the list before I looked, or my admin page was on another server. The automated tests pass step 7 because they open /admin within seconds after step 4 and search the whole list.

## Part 3: Robot Framework
- robot --version: Robot Framework 7.5.1 (Python 3.10.10 on win32)
- Step 3.2, failure message for the wrong title: `Title should have been 'Web Form' but was 'Web form'.`
- Step 3.8, run 1, result, elapsed time and pizza name: PASS, 15.4 s, `Lab Pizza 20261110-220418` (tool Scissors, 350 calories)
- Step 3.8, run 2, result, elapsed time and pizza name: PASS, 16.3 s, `Lab Pizza 20261110-220442` (tool Pizza, 325 calories)

## Part 4: Cypress
- node --version, npm --version and npx cypress version: v22.19.0, 11.17.0, Cypress 16.2.1
- Step 4.3, failure message for the wrong title: `Timed out retrying after 10000ms` with `-'Web form'` (actual) and `+'Web Form'` (expected)
- Step 4.6, tool and calories in the answer of POST /api/pizza: not read from the API response directly. The spec asserts that the page shows the same tool and calories as the response. Run 2 page showed Tool: Scissors, Calories per slice: 500.
- Step 4.7, the line of the admin list that shows your pizza (run 3, saved in the screenshot): `Lab Pizza 20261110-221823 (tool=Scissors, ingredients_number=8)` (another user's pizza was above it)
- Step 4.8, run 1, result, duration and pizza name: all specs passed, 00:26 (pizza-scenario 00:18, web-form 00:07), `Lab Pizza 20261110-221448` (tool=Pizza cutter)
- Step 4.8, run 2, result, duration and pizza name: all specs passed, 00:25 (pizza-scenario 00:20, web-form 00:04), `Lab Pizza 20261110-221605` (tool=Scissors)
- Step 4.8, run 3 (its screenshots and videos are the ones committed, because a later temporary spec made Cypress remove the files of run 2): all specs passed, 00:19 (pizza-scenario 00:15, web-form 00:04), `Lab Pizza 20261110-221823` (tool=Scissors)
- Step 4.9 (optional), browser and result: not done

## Part B
1. The three number boxes share the id `floating_filled`, and `$$("#floating_filled").length` returned 3, so an id cannot pick one of them. I find the box through the text of its label instead. If the page gave each input its own id or a `name` like `max-calories`, I could use it directly. This helps because the locator would no longer break when someone changes the label text or the layout around it.
2. It is a consistency oracle: two parts of the system, the admin list and the recommendation, must agree about the same pizza. It would catch a fault where the server saves a different tool than it returned, for example the recommendation says Scissors but the admin list shows tool=Knife. It would also fail if the pizza never reached the list.
3. The test could check the vegetarian field of the pizza. The response of POST /api/pizza has `"vegetarian": true`, and Cypress can already read it with `cy.intercept`, so the test would compare it with the ticked checkbox. A stronger check needs a list of which ingredients are vegetarian from another source, then checks every ingredient shown in the answer against that list.
4. Robot waited with explicit keywords such as `Wait Until Element Is Visible` and a 10 s library timeout, so I had to decide where each wait goes. Cypress retried `cy.get` and `should` for 10 s by itself, so my spec has no explicit wait. Cypress was faster to write, while Robot needed a resource file and keywords. The Robot log.html showed every step with a screenshot and was easier for finding a failure, and the Cypress video was nice to watch but harder to search. Runs took about 15 s in Robot and about 15 to 20 s in Cypress.
5. I would use Cypress for Project 2. First, its automatic retry removed all waits from my spec, and the rule of the project says waits must be on elements, not pauses. Second, `cy.intercept` let me check the request and the response against the page, and it needs no ChromeDriver setup, which saves time for the group.
6. If QuickPizza changed the locator of the calories box, I would change one line: the variable `${MAX CALORIES}` in `resources/quickpizza.resource`. `pizza_scenario.robot` only calls keywords like `Fill In The Pizza Request`, so it never contains the locator and stays the same.
7. Cypress clears the cookies before each test. QuickPizza runs on several servers and a cookie keeps one browser on one server, and the admin list shows only the pizzas of that server. If steps 6 and 7 were a second test, the browser could land on another server and the list would not hold my pizza, so step 7 would fail even though nothing is wrong.
