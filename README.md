# <u>QSResourceDirectory</u>

**iOS 13.5** | **Swift 5** | **Xcode Version 11.5 (11E608c)**

## Application Pages:

1. **Categories List Page**
   - [x] The list items must link to the resources page  
2. **Resource List Page**
   - [x] When I tap on the sort button, the list should sort from A-Z  
   - [x] When I tap on it a second time, it should sort the list from Z-A
   - [x] The list items must link to the details page
   - [x] The description is HTML, but what you see on the screen must be text  
3. **Resource Details Page**
   - [x] Actionable email link - email model
   - [x] Actionable phone numbers
   - [x] Actionable address map - to Maps App
   - [x] Actionable web link - web browser
   - [x] Display images
   - [x] Display description

---

### Notes:

- Focus on modular designs & DI

- Added a caching service to the photo fetching

- Due to time constraints the icons for the cells were not added & certain custom cell layouts

- Refactoring would be the next step to simplying the code base further

- Would have like to add more states to the view controllers 

- Would have been nice to include loading screens to simulate requests

- Some classes and models should have been exacted to their own files

  



---

# 

# Instructions:

- Fork this git repo to your computer
- Create a branch
- When you are done, push your work and create a pull request to the original repo.

# Requirements

*Create a 3 page app.*

- When you launch the app, you should see a list of resource categories (`/data/categories.json`)
- When you click on a category, it should open a list of resources (`/data/restaurant.json` or `/data/vacation-spot.json`)
- When you click on a resource, it should open a details page (see attached mockup)

# Tips:

- You can showcase usage of Dependency Injection and Architecture Component.
- You can show how to handle threads.
- Remember you can always create a side project first and prepare yourself before jumping into the test.
- For JSON, you can use the RAW file version in git hub so you can simulate a call to remote API.





# User Stories

|    |                                                                                      | Acceptance Criteria                                                             |
|----|--------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| 1  | As a user, I want to see a list of categories                                        | The list items must link to the resources page                                  |
| 2  | As a user, I want to see the resources inside a category                             | The list items must link to the details page                                    |
| 3  | As a user, I want to see the details of a category                                   | The description is HTML, but the what you see on the screen must be text        |
| 4  | As a user, I want to sort the list of resources alphabetically                       | When I tap on the sort button, the list should sort from A-Z                    |
| 5  | When I tap on it a second time, it should sort the list from Z-A                     | As a user, I want to send an email by tapping on a resource email               |
| 6  | It should open the email without leaving the app                                     | As a user, I want to call one of the phone numbers on the resource details page |
| 7  | As a user, I want to open the maps app on my phone when I tap on a resource address  |                                                                                 |
| 8  | As a user, I want to open a web link without leaving the app                         | It should open a web browser without leaving the app                            |
| 9  | As a user, I want to see a resource image                                            |                                                                                 |
| 10 | As a user, I want to see a resource description                                      |                                                                                 |

# Mockup:

Use the following mockup as a UI guide for your app (the image is at the root of the project). This mockup contains more details that you actually will need in this test. Please use with intepretation. We do not provide you with any specs, so please use your imagination while trying to respect the mockup as much as you can.

![Mockup](https://github.com/quickseries/mobile-test/blob/master/resources_android.png "Mockup")
