# pubup-app
Business locator and review iOS mobile application, integrating YelpFusionAPI to gather and retrieve local business data with the help of Firebase Firestore and Firebase Authentication to store business data, user data, and secure authentication.
  - Sources:
     - https://docs.developer.yelp.com/docs/fusion-intro
     - https://www.youtube.com/watch?v=-DSdeMlxlis&t=1408s&ab_channel=GaryTokman
     - https://www.youtube.com/watch?v=ZJ8oLWn2GwM&list=PL9VJ9OpT-IPSM6dFSwQCIl409gNBsqKTe&index=90&ab_channel=JohnGallaugher

### Includes TabBarView of three main pages
- Home
  - User is able to search for what they're looking for via a term
    - Ex: bar, asian food, mexican food, american cuisine, etc.
  - List of local businesses (based on approval of the app using the phone's location)
    - NavigationLink to details of said business information and user reviews
    - Side swipe to add business to favorites
- Favorites
  - Lists selected favorite businesses
- Account/Settings
  - Shows user email
  - Button to sign out
  - Color scheme option
 ![image](https://github.com/srburke/pubup-app/assets/15665394/4a725692-1946-42df-89d8-33ce654e38a1)
