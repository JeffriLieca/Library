# Library Management System

<p align="center">
  <img src="https://github.com/JeffriLieca/Library/raw/main/Library/Assets.xcassets/AppIcon.appiconset/Book_Lamp.jpg" width="300" />
</p>

A simple library management system built using SwiftUI and Supabase. This system allows users to view available books, borrow them, manage a cart for borrowing, and update returned book statuses. It supports functionalities like adding books, genres, and editions to the library, as well as tracking borrowing transactions and user profiles.

## Features

- **Book and Edition Management**: View and manage books and their editions.
- **Borrow Transactions**: Track borrowed books and update their status.
- **Cart System**: Add and remove books to/from the borrow cart.
- **User Management**: Login and fetch user profiles.
- **Supabase Integration**: Interacts with Supabase for fetching, adding, and updating records.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Supabase**: Used for managing data like books, editions, and borrow transactions.
- **Xcode**: The IDE used to develop the app.

## Features in Detail

### Book Management

- **View Books**: Fetch and display a list of all books in the library.
- **Add Books**: Add new books with title and authors.
- **Add Editions**: Add new editions for books with optional descriptions.

### Borrow Management

- **View Borrowed Books**: Fetch and display the books borrowed by the user.
- **Add Borrow Transaction**: Add a borrowing transaction by moving books to the cart and confirming the borrow.
- **Update Return Status**: Update the return status for borrowed books.

### Cart Management

- **Add to Cart**: Add books to the borrow cart.
- **Remove from Cart**: Remove books from the cart.
- **Clear Cart**: Clear all items from the cart before submitting a borrow transaction.

### User Authentication

- **Login**: Check if a user is logged in and fetch their profile information (Still simple, only if).

## Class Diagram

<p align="center">
  <img src="https://github.com/JeffriLieca/Library/raw/main/Document/Class-Diagram%20Library.png" width="800">
</p>

This class diagram was generated using the [SwiftPlantUML](https://github.com/MarcoEidinger/SwiftPlantUML) tool. A special thanks to **Marco Eidinger** for creating the [SwiftPlantUML](https://github.com/MarcoEidinger/SwiftPlantUML) technology, which made it possible to generate the class diagrams from Swift code.

## Database Structure

<p align="center">
  <img src="https://github.com/JeffriLieca/Library/raw/main/Document/Supabase%20Table.png" width="300">
</p>

The database schema is structured to support the library system's features and is fully integrated with Supabase for real-time data fetching and updates.

## Physical Data Model (PDM)

<p align="center">
  <img src="https://github.com/JeffriLieca/Library/raw/main/Document/PDM.png" width="300">
</p>

The PDM illustrates the relationships and structure of the database tables, ensuring efficient data storage and retrieval for the system's functionality.

## Unit Testing

<p align="center">
  <img src="https://github.com/JeffriLieca/Library/raw/main/Document/Unit%20Testing%20using%20Swift%20Testing.png" width="300">
</p>

I have also performed some unit testing using **Swift Testing**, a framework that Apple describes as having "expressive and intuitive APIs that make testing your Swift code a breeze."

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
