# Netherlands Locals Osusume

![Netherlands Locals Osusume](./app/assets/images/meta_image.png)

#### Video Demo: <https://youtu.be/sEYK2IutCyY>

#### Live on: <https://netherlands-locals-osusume.onrender.com/>

#### Description:

Hello, I'm Rio from Japan and this is my final project for Harvard's CS50, Netherlands Locals Osusume. This web app was built using Ruby on Rails, Bootstrap, Stimulus, Cloudinary, and PostgreSQL. When I started this course, I was living in the Netherlands, so I wanted to build something that could help Japanese people living in or traveling to the Netherlands. Thus, I created this app that allows local Japanese people to share their Osusume, in other words, their recommendations with other people. By using this app, you can avoid tourist traps, overcrowded places, bad restaurants, and ordinary attractions listed on every guide book. Instead, you will be able to enjoy the real hidden gems that only locals know and visit on a regular basis.

<hr/>

### Ruby on Rails

This project follows the MVC structure. Below I will explain the models, controllers, and views used for this application.

<hr/>

### User Journey

- A user can sign-up / log-in
- A user can update their account
- A user can create a Osusume
- A user can upload up to 4 images in their Osusume
- A user can update their own Osusume
- A user can delete their own Osusume
- A user can search for a keyword to view corresponding Osusumes
- A user can sort the Osusumes
- A user can filter the Osusumes
- A user can like a Osusume
- A user can share a Osusume
- A user can write a review for a Osusume
- A user can update their own review
- A user can delete their own review
- A user can check their profile
- A user can check all of the Osusume’s they’ve written
- A user can check their reviews they’ve written
- A user can check all of the Osusumes they’ve liked

<hr/>

### Users (Model, View) and Authentication

For authentication, I have decided to use Devise. The Devise gem creates the necessary user routes, models, and views. I have also included some extra user fields: user name and is_admin. Each route is authenticated before it can be reached, except for the root (index page showing all Osusumes) and the Osusume show page. In the User model, I've specified that a user has many recommendations, many likes, and many reviews.

<hr/>

### Recommendation Model (Osusume)

The Recommendation model consists of a name, description, visit date, address, recommendation type (enum: Restaurant, Cafe, Shop, Event, Park, Bakery, Market, Scenery, and Other), rating, website url, instagram url, price (enum: Free, €1-10, €10-30, and €30+ ), likes count, and a user id (foreign key to User model). A recommendation has many reviews (comments) and likes as well. The Recommendation model also uses Active Records in order to attach multiple images from Cloudinary.

### Recommendation Views

<strong>Index:</strong> Displays all of the Osusumes Cards. Osusume Cards use a carousel in order to go through multiple images. It also shows a “New” badge if the Osusume was created within a week. The card displays the Name, type of the Osusume, Ratings, and the number of comments (Ratings and review count are only shown if the Osusume has at least one comment). It also shows a search box and drop-downs to filter and sort the results. Uses Stimulus to dynamically change the results.

<strong>Show:</strong> Similar to the Osusume Card but this one shows additional information such as address, price, website url, instagram url, description, date of visit, and comments left by users. Uses Stimulus to display a modal containing the form to write a new review.

<strong>Edit:</strong> A prefilled form with fields to update the corresponding Osusume.

<strong>New:</strong> A new form with fields to create a Osusume.

### Recommendation Controller

<strong>Index:</strong> Queries the database to get all of the Osusumes and the number of Osusumes. Checks the query from the search box and the sort and filter options sent from the view.

<strong>Show:</strong> Queries the database to get a single Osusume. Also get all of the reviews for that Osusume. Finally, it has Review.new for the new review.

<strong>New:</strong> Recommendation.new to create a new Recommendation.

<strong>Create:</strong> Get the recommendation params based on what the user has filled in. Assign the current user to the created Recommendation. Redirect to the show page if the recommendation is saved correctly or else display the form errors.

<strong>Edit:</strong> Get the recommendation. Only allow edit if the recommendation is created by the current user or is an admin.

<strong>Update:</strong> Get the recommendation params. Only allow update if the recommendation is created by the current user or is an admin. Deletes photos if there are new photos attached. Redirect to the show page if the recommendation is updated correctly or else display the form errors.

<strong>Destroy:</strong> Get the recommendation params. Only allow destory if the recommendation is created by the current user or is an admin. Deletes photos if there are any photos attached. Redirect to the index page once recommendation is destroyed.

<hr/>

### Review Model

The Review model consists of text, rating, visit date, user id (foreign key to User model), and a recommendation id (foreign key to Recommendation model). The review model also validates that a user can only create a single review for a recommendation. A review belongs to a user and belongs to a recommendation.

### Review Views

<strong>New:</strong> None. A review form can be checked in the recommendation show page. Uses flatpickr package for choosing dates and star rating package to set a rating.

<strong>Edit:</strong> A prefilled form with fields to update the corresponding review. Can update rating, text, and visit date.

### Review Controller

<strong>Create:</strong> Get the review params based on what the user has filled in. Assign the current user and recommendation to the created review. Checks if the user has already created a review. Uses transaction to prevent race conditions. Uses Stimulus to display the new review in recommendation show page if saved correctly or else display the form errors. It also has a method to update the recommendation rating everytime a review is successfully saved.

<strong>Edit:</strong> Get the review. Only allow edit if the review is created by the current user or is an admin. Uses transaction to prevent race conditions. It also has a method to update the recommendation rating everytime a review is successfully updated.

<strong>Destroy:</strong> Get the review. Only allow destroy if the review is created by the current user or is an admin. Uses transaction to prevent race conditions. It also has a method to update the recommendation rating everytime a review is successfully updated .Redirect to the recommendation show page once review is destroyed.

<hr/>

### Like Model

The Like model consists of a user id (foreign key to User model), and a recommendation id (foreign key to Recommendation model). The like model also validates that a user can only have one like for a recommendation.

### Like Views

None. Just a jbuilder file to update the heart icon found in recommendations show page and in the recommendation card (recommendation index).

### Like Controller

<strong>Create:</strong> Get the recommendation and create a like with the current user. Render the json with liked as true if the like is saved successfully. Else, display the corresponding error.

<strong>Destroy:</strong> Check if the current recommendation is liked by the current user. Render the json with liked as false if the like is destroyed successfully. Else, display the corresponding error.

<hr/>

### Profile Views

<strong>Show:</strong> Display the current user's username, date in which the account was created, posted osusumes, and a link to the profiles reviews page.

<strong>Reviews:</strong> Show all the reviews written by the current user. Shows the review tile which contains the image of the recommendation, name of the recommendation, given rating, date, and the review text.

<strong>Likes:</strong> Show all the recommendations liked by the current user. Shows the like tile which contains the image of the recommendation and name of the recommendation.

### Profile Controller

<strong>Show:</strong> Get the user. Query all of the recommendations created by that user.

<strong>Reviews:</strong> Get all the reviews created by the current user including the recommendation.

<strong>Likes:</strong> Get all the likes from the current user including the recommendation.

### Render

This web app is live via Render 🌐

*I'm using the free version so it might take a while to load if the app is inactive.

https://netherlands-locals-osusume.onrender.com/
