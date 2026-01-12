# Assignment: iOS Developer

Build a Route Planner with Midpoint Marker using SwiftUl & MapKit

Create an iOS application in SwiftUl that helps users plan routes and visualize the midpoint.

---

## Part 1: Architecture Design Presentation (10-15 minutes)

Before you start coding, create an architecture design (UML) diagram and present it to us.

---

## Part 2: Implementation (60 minutes)

### Screen 1: Address Input

• Two text fields: "Start Address" and "End Address"  

• "Show Route" button with validation  

• Loading indicator and error messages  

---

### Screen 2: Route Map

• Map with route polyline  

• Green mark (start), Red mark (end), Blue mark (midpoint of route) - colors is nice to have  

• Display distance and duration  

• Back button  

---

## Part 3: Future Improvements (5 minutes)

Write what you would add with more time.

---

## Technical Requirements

The solution should follow modern Swift standards and best practices

---

## Must Have:

### Architecture & Code Quality

• SwiftUl using MVVM  

• async/await for all asynchronous work  

• MainActor to ensure thread-safe Ul updates  

• Protocol-based dependencies with dependency injection  

• Clean separation of concerns (no business logic in Views)  

---

### MapKit & Concurrency

• Calculate and show the midpoint along the route polyline (based on the path distance), not the direct geometric midpoint between two coordinates.  

• Automatically adjust the map's visible region to fit and display the entire route.  

---

## Nice to Have (Bonus)

• Provide smooth animations for screen transitions, pin drops, and route rendering.  

• When a marker is tapped, display its location details (including the address).  

• Error Handling  

• "Use Current Location" option.  
