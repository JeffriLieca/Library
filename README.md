# Library Management System

<img src="https://github.com/JeffriLieca/Library/raw/main/Library/Assets.xcassets/AppIcon.appiconset/Book_Lamp.jpg" width="300" />


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
  

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
